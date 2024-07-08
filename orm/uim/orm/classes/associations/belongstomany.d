/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.orm.classes.associations.belongstomany;

import uim.orm;

@safe:

/**
 * Represents an M - N relationship where there exists a junction - or join - table
 * that contains the association fields between the source and the target table.
 *
 * An example of a BelongsToMany association would be Article belongs to many Tags.
 * In this example "Article" is the source table and "Tags" is the target table.
 */
class DBelongsToManyAssociation : DAssociation {
    mixin(AssociationThis!("BelongsToMany"));

    // Saving strategy that will only append to the links set
    const string SAVE_APPEND = "append";

    // Saving strategy that will replace the links with the provided set
    const string SAVE_REPLACE = "replace";

    // Junction table name
    protected string _junctionTableName;

    // The name of the hasMany association from the target table to the junction table
    protected string _junctionAssociationName;

    /**
     * The name of the property to be set containing data from the junction table
     * once a record from the target table is hydrated
     */
    protected string _junctionProperty = "_joinData";

    // The type of join to be used when adding the association to a query
    protected string _joinType = DQuery.JOIN_TYPE_INNER;

    // The strategy name to be used to fetch associated records.
    protected string _strategy = STRATEGY_SELECT;

    // Junction table instance
    protected DORMTable _junctionTable;

    // Saving strategy to be used by this association
    protected string _saveStrategy = SAVE_REPLACE;

    // The name of the field representing the foreign key to the target table
    protected string[] _targetForeignKeys;

    // The table instance for the junction relation.
    protected DORMTable _through;

    // Valid strategies for this type of association
    protected  string[]_validStrategies = [
        STRATEGY_SELECT,
        STRATEGY_SUBQUERY,
    ];

    /**
     * Whether the records on the joint table should be removed when a record
     * on the source table is deleted.
     *
     * Defaults to true for backwards compatibility.
     */
    protected bool _dependent = true;

    // Filtered conditions that reference the target table.
    protected Json[string] _targetConditions;

    // Filtered conditions that reference the junction table.
    protected Json[string] _junctionConditions;

    // Order in which target records should be returned
    protected Json[string] _sortOrder;

    // Sets the name of the field representing the foreign key to the target table.
    void tarforeignKeys(string[] keys) {
        _targetForeignKeys = keys;
    }

    // Gets the name of the field representing the foreign key to the target table.
    string[] tarforeignKeys() {
        if (_targetForeignKeys == null) {
            // TODO _targetForeignKeys = _modelKey(getTarget().aliasName());
        }

        return _targetForeignKeys;
    }

    // Whether this association can be expressed directly in a query join
    bool canBeJoined(Json[string] options = null) {
        return options.hasKey("matching");
    }

    // Gets the name of the field representing the foreign key to the source table.
    string[] foreignKeys() {
        if (_foreignKey == null) {
            // TODO _foreignKey = _modelKey(source().getTable());
        }

        return _foreignKey;
    }

    // Sets the sort order in which target records should be returned.
    void sortOrder(Json sortOrder) {
        _sortOrder = sortOrder;
    }

    // Gets the sort order in which target records should be returned.
    Json sortOrder() {
        return _sortOrder;
    }

    Json defaultRowValue(Json[string] row, bool joined) {
        string sourceAlias = source().aliasName();
        if (ro.hasKey(sourceAlias)) {
            row[sourceAlias][getProperty()] = joined ? null : [];
        }

        return row;
    }

    /**
     * Sets the table instance for the junction relation. If no arguments
     * are passed, the current configured table instance is returned
     */
    DORMTable junction(DORMTable /* string */ table = null) {
        if (table == null && _junctionTable != null) {
            return _junctionTable;
        }

        auto tableLocator = getTableLocator();
        if (table == null && _through) {
            table = _through;
        } elseif (table == null) {
            tableName = _junctionTableName();
            tableAlias = Inflector.camelize(tableName);

            myConfiguration = null;
            if (!tableLocator.exists(tableAlias)) {
                myConfiguration = ["table": tableName, "allowFallbackClass": true.toJson];

                // Propagate the connection if we"ll get an auto-model
                if (!App.classname(tableAlias, "Model/Table", "Table")) {
                    configuration.get("connection") = source().getConnection();
                }
            }
            table = tableLocator.get(tableAlias, myConfiguration);
        }

        if (table.isString) {
            table = tableLocator.get(table);
        }

        source = source();
        target = getTarget();
        if (source.aliasName() == target.aliasName()) {
            throw new DInvalidArgumentException(
                "The `%s` association on `%s` cannot target the same table."
                .format(getName(), source.aliasName())
           );
        }

        _generateSourceAssociations(table, source);
        _generateTargetAssociations(table, source, target);
        _generateJunctionAssociations(table, source, target);

        return _junctionTable = table;
    }

    /**
     * Generate reciprocal associations as necessary.
     *
     * Generates the following associations:
     *
     * - target hasMany junction e.g. Articles hasMany ArticlesTags
     * - target belongsToMany source e.g Articles belongsToMany Tags.
     *
     * You can override these generated associations by defining associations
     * with the correct aliases.
     */
    protected void _generateTargetAssociations(DORMTable junction, DORMTable source, DORMTable target) {
        string junctionAlias = junction.aliasName();
        string sourceAlias = source.aliasName();
        string targetAlias = target.aliasName();

        auto targetBindingKey = null;
        if (junction.hasAssociation(targetAlias)) {
            targetBindingKey = junction.getAssociation(targetAlias).getBindingKey();
        }

        if (!target.hasAssociation(junctionAlias)) {
            target.hasMany(junctionAlias, [
                "targetTable": junction,
                "bindingKey": targetBindingKey,
                "foreignKeys": tarforeignKeys(),
                "strategy": _strategy,
            ]);
        }
        if (!target.hasAssociation(sourceAlias)) {
            target.belongsToMany(sourceAlias, [
                "sourceTable": target,
                "targetTable": source,
                "foreignKeys": tarforeignKeys(),
                "targetForeignKey": foreignKeys(),
                "through": junction,
                "conditions": getConditions(),
                "strategy": _strategy,
            ]);
        }
    }

    /**
     * Generate additional source table associations as necessary.
     *
     * Generates the following associations:
     * - source hasMany junction e.g. Tags hasMany ArticlesTags
     *
     * You can override these generated associations by defining associations
     * with the correct aliases.
     */
    protected void _generateSourceAssociations(DORMTable junctionTable, DORMTable sourceTable) {
        string junctionAlias = junctionTable.aliasName();
        string sourceAlias = source.aliasName();

        sourceBindingKey = null;
        if (junctionTable.hasAssociation(sourceAlias)) {
            sourceBindingKey = junctionTable.getAssociation(sourceAlias).getBindingKey();
        }

        if (!source.hasAssociation(junctionAlias)) {
            source.hasMany(junctionAlias, [
                "targetTable": junctionTable,
                "bindingKey": sourceBindingKey,
                "foreignKeys": foreignKeys(),
                "strategy": _strategy,
            ]);
        }
    }

    /**
     * Generate associations on the junction table as necessary
     *
     * Generates the following associations:
     *
     * - junction belongsTo source e.g. ArticlesTags belongsTo Tags
     * - junction belongsTo target e.g. ArticlesTags belongsTo Articles
     *
     * You can override these generated associations by defining associations
     * with the correct aliases.
     *
     * @param DORMTable junction The junction table.
     * @param DORMTable source The source table.
     * @param DORMTable target The target table.
     */
    protected void _generateJunctionAssociations(DORMTable junctionTable, DORMTable source, DORMTable targetTable) {
        auto targetAlias = targetTable.aliasName();
        auto sourceAlias = source.aliasName();

        if (!junctionTable.hasAssociation(targetAlias)) {
            junctionTable.belongsTo(targetAlias, [
                "foreignKeys": tarforeignKeys(),
                "targetTable": targetTable,
            ]);
        } else {
            belongsTo = junctionTable.getAssociation(targetAlias);
            if (
                tarforeignKeys() != belongsTo.foreignKeys() ||
                targetTable != belongsTo.getTarget()
           ) {
                throw new DInvalidArgumentException(
                    "The existing `{targetAlias}` association on `{junctionTable.aliasName()}` " ~
                    "is incompatible with the `{getName()}` association on `{source.aliasName()}`"
               );
            }
        }

        if (!junctionTable.hasAssociation(sourceAlias)) {
            junctionTable.belongsTo(sourceAlias, [
                "bindingKey": getBindingKey(),
                "foreignKeys": foreignKeys(),
                "targetTable": source,
            ]);
        }
    }

    /**
     * Alters a Query object to include the associated target table data in the final
     * result
     *
     * The options array accept the following keys:
     *
     * - includeFields: Whether to include target model fields in the result or not
     * - foreignKeys: The name of the field to use as foreign key, if false none
     *  will be used
     * - conditions: array with a list of conditions to filter the join with
     * - fields: a list of fields in the target table to include in the result
     * - type: The type of join to be used (e.g. INNER)
     */
    void attachTo(DORMQuery query, Json[string] options = null) {
        if (!options.isEmpty("negateMatch")) {
            _appendNotMatching(query, options);

            return;
        }

        auto junction = this.junction();
        auto belongsTo = junction.getAssociation(source().aliasName());
        auto cond = belongsTo._joinCondition(["foreignKeys": belongsTo.foreignKeys()]);
        cond += this.junctionConditions();

        includeFields = options.get("includeFields", null);

        // Attach the junction table as well we need it to populate _joinData.
        auto assoc = _targetTable.getAssociation(junction.aliasName());
        auto newOptions = array_intersectinternalKey(options, ["joinType": 1, "fields": 1]);
        newOptions += [
            "conditions": cond,
            "includeFields": includeFields,
            "foreignKeys": false.toJson,
        ];
        assoc.attachTo(query, newOptions);
        query.getEagerLoader().addToJoinsMap(junction.aliasName(), assoc, true);

        super.attachTo(query, options);

        foreignKeys = tarforeignKeys();
        thisJoin = query.clause("join")[getName()];
        thisJoin["conditions"].add(assoc._joinCondition(["foreignKeys": foreignKeys]));
    }


    protected void _appendNotMatching(Query query, Json[string] options = null) {
        if (options.isEmpty("negateMatch")) {
            return;
        }
        options.set("conditions", options.getArray("conditions"));
        auto junction = this.junction();
        auto belongsTo = junction.getAssociation(source().aliasName());
        auto conds = belongsTo._joinCondition(["foreignKeys": belongsTo.foreignKeys()]);

        auto subquery = this.find()
            .select(array_values(conds))
            .where(options["conditions"]);

        if (!options.isEmpty("queryBuilder")) {
            subquery = options.get("queryBuilder")(subquery);
        }

        subquery = _appendJunctionJoin(subquery);

        query
            .andWhere(function (QueryExpression exp) use (subquery, conds) {
                auto identifiers = conds.keys.map!(field => new DIdentifierExpression(field));
                identifiers = subquery.newExpr().add(identifiers).conjunctionType(",");
                nullExp = exp.clone;

                return exp
                    .or([
                        exp.notIn(identifiers, subquery),
                        nullExp.and(array_map([nullExp, "isNull"], conds.keys)),
                    ]);
            });
    }

    /**
     * Get the relationship type.
     */
    string type() {
        return MANY_TO_MANY;
    }

    /**
     * Return false as join conditions are defined in the junction table
     *
     * @param Json[string] options list of options passed to attachTo method
     */
    protected Json[string] _joinCondition(Json[string] options = null) {
        return [];
    }


    function eagerLoader(Json[string] options = null): Closure
    {
        name = _junctionAssociationName();
        loader = new DSelectWithPivotLoader([
            "alias": this.aliasName(),
            "sourceAlias": source().aliasName(),
            "targetAlias": getTarget().aliasName(),
            "foreignKeys": foreignKeys(),
            "bindingKey": getBindingKey(),
            "strategy": getStrategy(),
            "associationType": this.type(),
            "sort": getSort(),
            "junctionAssociationName": name,
            "junctionProperty": _junctionProperty,
            "junctionAssoc": getTarget().getAssociation(name),
            "junctionConditions": this.junctionConditions(),
            "finder": function () {
                return _appendJunctionJoin(this.find(), []);
            },
        ]);

        return loader.buildEagerLoader(options);
    }

    /**
     * Clear out the data in the junction table for a given entity.
     *
     * @param DORMDatasource\IORMEntity anEntity The entity that started the cascading delete.
     * @param Json[string] options The options for the original delete.
     */
    bool cascadeRemove(IORMEntity anEntity, Json[string] options = null) {
        if (!getDependent()) {
            return true;
        }

        auto foreignKeys = foreignKeys();
        auto bindingKeys = bindingKeys();
        auto bindingKeys = null;
        if (!bindingKey.isEmpty) {
            conditions = chain(foreignKeys, entity.extract(bindingKeyx));
        }

        auto table = this.junction();
        auto hasMany = source().getAssociation(table.aliasName());
        if (_cascadeCallbacks) {
            return hasMany.find("all").where(conditions).all().toList()
                .all!(related => table.remove(related, options));
        }

        auto assocConditions = hasMany.getConditions();
        if (assocConditions.isArray) {
            conditions = array_merge(conditions, assocConditions);
        } else {
            conditions ~= assocConditions;
        }

        table.deleteAll(conditions);
        return true;
    }

    /**
     * Returns boolean true, as both of the tables "own" rows in the other side
     * of the association via the joint table.
     */
    bool isOwningSide(DORMTable tableWithOwnership) {
        return true;
    }

    /**
     * Sets the strategy that should be used for saving.
     */
     void setSaveStrategy(string strategyName) {
        if (![SAVE_APPEND, SAVE_REPLACE].has(strategyName)) {
            string message = "Invalid save strategy '%s'".format(strategyName);
            throw new DInvalidArgumentException(message);
        }

        _saveStrategy = strategyName;
    }

    // Gets the strategy that should be used for saving.
    string getSaveStrategy() {
        return _saveStrategy;
    }

    /**
     * Takes an entity from the source table and looks if there is a field
     * matching the property name for this association. The found entity will be
     * saved on the target table for this association by passing supplied
     * `options`
     *
     * When using the "append" strategy, this function will only create new links
     * between each side of this association. It will not destroy existing ones even
     * though they may not be present in the array of entities to be saved.
     *
     * When using the "replace" strategy, existing links will be removed and new links
     * will be created in the joint table. If there exists links in the database to some
     * of the entities intended to be saved by this method, they will be updated,
     * not deleted.
     *
     * @param DORMDatasource\IORMEntity anEntity an entity from the source table
     */
    IORMEntity saveAssociated(IORMEntity ormEntity, Json[string] options = null) {
        auto targetEntity = entity.get(getProperty());
        auto strategy = getSaveStrategy();

        bool isEmpty = isIn(targetEntity, [null, [], "", false], true);
        if (isEmpty && ormEntity.isNew()) {
            return ormEntity;
        }
        if (isEmpty) {
            targetEntity = null;
        }

        if (strategy == SAVE_APPEND) {
            return _saveTarget(ormEntity, targetEntity, options);
        }

        if (replaceLinks(ormEntity, targetEntity, options)) {
            return ormEntity;
        }

        return false;
    }

    /**
     * Persists each of the entities into the target table and creates links between
     * the parent entity and each one of the saved target entities.
     *
     * @param DORMDatasource\IORMEntity parentEntity the source entity containing the target
     * entities to be saved.
     * @param Json[string] entities list of entities to persist in target table and to
     * link to the parent entity
     * @param Json[string] options list of options accepted by `Table.save()`
     */
    protected IORMEntity _saveTarget(IORMEntity parentEntity, Json[string] entities, options) {
        auto joinAssociations = false;
        if (options.hasKey("associated"]) && options["associated"].isArray) {
            if (!options.isEmpty("associated"][_junctionProperty]["associated"])) {
                joinAssociations = options.get("associated"][_junctionProperty]["associated"];
            }
            options.remove("associated"][_junctionProperty]);
        }

        auto table = getTarget();
        auto original = entities;
        auto persisted = null;

        foreach (k, entity; entities) {
            if (!cast(IORMEntity)entity) {
                break;
            }

            if (!options.isEmpty("atomic")) {
                entity = entity.clone;
            }

            saved = table.save(entity, options);
            if (saved) {
                entities[k] = entity;
                persisted ~= entity;
                continue;
            }

            // Saving the new linked entity failed, copy errors back into the
            // original entity if applicable and abort.
            if (!options.isEmpty("atomic"])) {
                original[k].setErrors(entity.getErrors());
            }
            if (saved == false) {
                return false;
            }
        }

        options["associated"] = joinAssociations;
        success = _saveLinks(parentEntity, persisted, options);
        if (!success && !options.isEmpty("atomic"])) {
            parentEntity.set(getProperty(), original);

            return false;
        }

        parentEntity.set(getProperty(), entities);

        return parentEntity;
    }

    /**
     * Creates links between the source entity and each of the passed target entities
     *
     * @param DORMDatasource\IORMEntity sourceEntity the entity from source table in this
     * association
     * @param array<DORMDatasource\IORMEntity> targetEntities list of entities to link to link to the source entity using the
     * junction table
     * @param Json[string] options list of options accepted by `Table.save()`
     */
    protected bool _saveLinks(IORMEntity sourceEntity, Json[string] targetEntities, Json[string] options = null) {
        auto target = getTarget();
        auto junction = this.junction();
        auto entityClass = junction.getEntityClass();
        auto belongsTo = junction.getAssociation(target.aliasName());
        auto foreignKeys = (array)foreignKeys();
        auto assocForeignKey = /* (array) */belongsTo.foreignKeys();
        auto targetBindingKey = /* (array) */belongsTo.getBindingKey();
        auto bindingKey = /* (array) */getBindingKey();
        auto jointProperty = _junctionProperty;
        auto junctionRegistryAlias = junction.registryKey();

        foreach (e; targetEntities) {
            joint = e.get(jointProperty);
            if (!joint || !cast(IORMEntity)joint) {
                joint = new DORMEntityClass([], ["markNew": true.toJson, "source": junctionRegistryAlias]);
            }
            sourceKeys = array_combine(foreignKeys, sourceEntity.extract(bindingKey));
            targetKeys = array_combine(assocForeignKey, e.extract(targetBindingKey));

            changedKeys = (
                sourceKeys != joint.extract(foreignKeys) ||
                targetKeys != joint.extract(assocForeignKey)
           );
            // Keys were changed, the junction table record _could_ be
            // new. By clearing the primary key values, and marking the entity
            // as new, we let save() sort out whether we have a new link
            // or if we are updating an existing link.
            if (changedKeys) {
                joint.setNew(true);
                joint.remove(junction.primaryKeys())
                    .set(array_merge(sourceKeys, targetKeys), ["guard": false.toJson]);
            }
            saved = junction.save(joint, options);

            if (!saved && !options.isEmpty("atomic")) {
                return false;
            }

            e.set(jointProperty, joint);
            e.setDirty(jointProperty, false);
        }

        return true;
    }

    /**
     * Associates the source entity to each of the target entities provided by
     * creating links in the junction table. Both the source entity and each of
     * the target entities are assumed to be already persisted, if they are marked
     * as new or their status is unknown then an exception will be thrown.
     *
     * When using this method, all entities in `targetEntities` will be appended to
     * the source entity"s property corresponding to this association object.
     *
     * This method does not check link uniqueness.
     *
     * ### Example:
     *
     * ```
     * newTags = tags.find("relevant").toJString();
     * articles.getAssociation("tags").link(article, newTags);
     * ```
     *
     * `article.get("tags")` will contain all tags in `newTags` after liking
     *
     * @param DORMDatasource\IORMEntity sourceEntity the row belonging to the `source` side
     *  of this association
     * @param array<DORMDatasource\IORMEntity> targetEntities list of entities belonging to the `target` side
     *  of this association
     * @param Json[string] options list of options to be passed to the internal `save` call
     * @return bool true on success, false otherwise
     */
    bool link(IORMEntity sourceEntity, Json[string] targetEntities, Json[string] options = null) {
        _checkPersistenceStatus(sourceEntity, targetEntities);
        property = getProperty();
        links = sourceEntity.get(property) ?: [];
        links = array_merge(links, targetEntities);
        sourceEntity.set(property, links);

        return _junction().getConnection().transactional(
            function () use (sourceEntity, targetEntities, options) {
                return _saveLinks(sourceEntity, targetEntities, options);
            }
       );
    }

    /**
     * Removes all links between the passed source entity and each of the provided
     * target entities. This method assumes that all passed objects are already persisted
     * in the database and that each of them contain a primary key value.
     *
     * ### Options
     *
     * Additionally to the default options accepted by `Table.remove()`, the following
     * keys are supported:
     *
     * - cleanProperty: Whether to remove all the objects in `targetEntities` that
     * are stored in `sourceEntity` (default: true)
     *
     * By default this method will unset each of the entity objects stored inside the
     * source entity.
     *
     * ### Example:
     *
     * ```
     * article.tags = [tag1, tag2, tag3, tag4];
     * tags = [tag1, tag2, tag3];
     * articles.getAssociation("tags").unlink(article, tags);
     * ```
     *
     * `article.get("tags")` will contain only `[tag4]` after deleting in the database
     *
     * @param DORMDatasource\IORMEntity sourceEntity An entity persisted in the source table for
     *  this association.
     * @param array<DORMDatasource\IORMEntity> targetEntities List of entities persisted in the target table for
     *  this association.
     * @param string[]|bool options List of options to be passed to the internal `delete` call,
     *  or a `boolean` as `cleanProperty` key shortcut.
     */
    bool unlink(IORMEntity sourceEntity, Json[string] targetEntities, options = null) {
        if (is_bool(options)) {
            options = [
                "cleanProperty": options,
            ];
        } else {
            auto updatedOptions = options.update["cleanProperty": true.toJson];
        }

        _checkPersistenceStatus(sourceEntity, targetEntities);
        property = getProperty();

        this.junction().getConnection().transactional(
            void () use (sourceEntity, targetEntities, options) {
                links = _collectJointEntities(sourceEntity, targetEntities);
                links.each!(entity => _junctionTable.remove(entity, options));
            }
       );

        /** @var array<DORMDatasource\IORMEntity> existing */
        auto existing = sourceEntity.get(property) ?: [];
        if (!options.hasKey("cleanProperty"] || existing.isEmpty) {
            return true;
        }

        /** @var \SplObjectStorage<DORMDatasource\IORMEntity, null> storage */
        storage = new DSplObjectStorage();
        foreach (targetEntities as e) {
            storage.attach(e);
        }

        existing.byKeyValue.each!((keyEntity){
            if (storage.contains(keyEntity.value)) {
                existing.remove(keyEntity.key);
            }
        });

        sourceEntity.set(property, array_values(existing));
        sourceEntity.setDirty(property, false);

        return true;
    }


    void setConditions(conditions) {
        super.setConditions(conditions);
        _targetConditions = _junctionConditions = null;
    }

    // Sets the current join table, either the name of the Table instance or the instance it
    void setThrough(through) {
        _through = through;
    }

    // Gets the current join table, either the name of the Table instance or the instance it
    DORMTable getThrough() {
        return _through;
    }

    /**
     * Returns filtered conditions that reference the target table.
     *
     * Any string expressions, or expression objects will
     * also be returned in this list.
     */
    protected json[string] targetConditions() {
        if (_targetConditions != null) {
            return _targetConditions;
        }

        auto conditions = getConditions();
        if (!conditions.isArray) {
            return conditions;
        }
        matching = null;
        auto aliasName = this.aliasName() ~ ".";
        foreach (conditions as field: value) {
            if (field.isString && indexOf(field, alialiasNameas) == 0) {
                matching[field] = value;
            } elseif (is_int(field) || cast(IExpression)value) {
                matching[field] = value;
            }
        }

        return _targetConditions = matching;
    }

    /**
     * Returns filtered conditions that specifically reference
     * the junction table.
     *
     */
    protected Json[string] junctionConditions() {
        if (_junctionConditions != null) {
            return _junctionConditions;
        }
        matching = null;
        conditions = getConditions();
        if (!(conditions.isArray) {
            return matching;
        }
        aliasName = _junctionAssociationName() ~ ".";
        foreach (conditions as field: value) {
            isString = field.isString;
            if (isString && indexOf(field, alias) == 0) {
                matching[field] = value;
            }
            // Assume that operators contain junction conditions.
            // Trying to manage complex conditions could result in incorrect queries.
            if (isString && isIn(strtoupper(field), ["OR", "NOT", "AND", "XOR"], true)) {
                matching[field] = value;
            }
        }

        return _junctionConditions = matching;
    }

    /**
     * Proxies the finding operation to the target table"s find method
     * and modifies the query accordingly based of this association
     * configuration.
     *
     * If your association includes conditions or a finder, the junction table will be
     * included in the query"s contained associations.
     *
     * @param Json[string]|string type the type of query to perform, if an array is passed,
     *  it will be interpreted as the `options` parameter
     * @param Json[string] options The options to for the find
    Query find(type = null, Json[string] options = null) {
        type = type ?: getFinder();
        [type, opts] = _extractFinder(type);
        query = getTarget()
            .find(type, options + opts)
            .where(this.targetConditions())
            .addDefaultTypes(getTarget());

        if (this.junctionConditions()) {
            return _appendJunctionJoin(query);
        }

        return query;
    }

    /**
     * Append a join to the junction table.
     *
     * @param DORMQuery query The query to append.
     * @param array|null conditions The query conditions to use.
     */
    protected DORMQuery _appendJunctionJoin(Query query, array conditions = null) {
        junctionTable = this.junction();
        if (conditions == null) {
            belongsTo = junctionTable.getAssociation(getTarget().aliasName());
            conditions = belongsTo._joinCondition([
                "foreignKeys": tarforeignKeys(),
            ]);
            conditions += this.junctionConditions();
        }

        name = _junctionAssociationName();
        /** @var array joins */
        joins = query.clause("join");
        matching = [
            name: [
                "table": junctionTable.getTable(),
                "conditions": conditions,
                "type": Query.JOIN_TYPE_INNER,
            ],
        ];

        query
            .addDefaultTypes(junctionTable)
            .join(matching + joins, [], true);

        return query;
    }

    /**
     * Replaces existing association links between the source entity and the target
     * with the ones passed. This method does a smart cleanup, links that are already
     * persisted and present in `targetEntities` will not be deleted, new links will
     * be created for the passed target entities that are not already in the database
     * and the rest will be removed.
     *
     * For example, if an article is linked to tags "uim" and "framework" and you pass
     * to this method an array containing the entities for tags "uim", "d" and "awesome",
     * only the link for uim will be kept in database, the link for "framework" will be
     * deleted and the links for "d" and "awesome" will be created.
     *
     * Existing links are not deleted and created again, they are either left untouched
     * or updated so that potential extra information stored in the joint row is not
     * lost. Updating the link row can be done by making sure the corresponding passed
     * target entity contains the joint property with its primary key and any extra
     * information to be stored.
     *
     * On success, the passed `sourceEntity` will contain `targetEntities` as value
     * in the corresponding property for this association.
     *
     * This method assumes that links between both the source entity and each of the
     * target entities are unique. That is, for any given row in the source table there
     * can only be one link in the junction table pointing to any other given row in
     * the target table.
     *
     * Additional options for new links to be saved can be passed in the third argument,
     * check `Table.save()` for information on the accepted options.
     *
     * ### Example:
     *
     * ```
     * article.tags = [tag1, tag2, tag3, tag4];
     * articles.save(article);
     * tags = [tag1, tag3];
     * articles.getAssociation("tags").replaceLinks(article, tags);
     * ```
     *
     * `article.get("tags")` will contain only `[tag1, tag3]` at the end
     *
     * @param DORMDatasource\IORMEntity sourceEntity an entity persisted in the source table for
     *  this association
     * @param Json[string] targetEntities list of entities from the target table to be linked
     */
    bool replaceLinks(IORMEntity sourceEntity, Json[string] targetEntities, Json[string] options = null) {
        auto bindingKey = /* (array) */getBindingKey();
        auto primaryValue = sourceEntity.extract(bindingKey);

        if (count(Hash.filter(primaryValue)) != count(bindingKey)) {
            string message = "Could not find primary key value for source entity";
            throw new DInvalidArgumentException(message);
        }

        return _junction().getConnection().transactional(
            function () use (sourceEntity, targetEntities, primaryValue, options) {
                junction = this.junction();
                target = getTarget();

                foreignKeys = /* (array) */foreignKeys();
                assocForeignKey = (array)junction.getAssociation(target.aliasName()).foreignKeys();

                prefixedForeignKey = array_map([junction, "aliasField"], foreignKeys);
                junctionPrimaryKey = (array)junction.primaryKeys();
                junctionQueryAlias = junction.aliasName() ~ "__matches";

                keys = matchesConditions = null;
                foreach (array_merge(assocForeignKey, junctionPrimaryKey) as key) {
                    aliased = junction.aliasField(key);
                    keys[key] = aliased;
                    matchesConditions[aliased] = new DIdentifierExpression(junctionQueryAlias ~ "." ~ key);
                }

                // Use association to create row selection
                // with finders & association conditions.
                matches = _appendJunctionJoin(this.find())
                    .select(keys)
                    .where(array_combine(prefixedForeignKey, primaryValue));

                // Create a subquery join to ensure we get
                // the correct entity passed to callbacks.
                existing = junction.query()
                    .from([junctionQueryAlias: matches])
                    .innerJoin(
                        [junction.aliasName(): junction.getTable()],
                        matchesConditions
                   );

                jointEntities = _collectJointEntities(sourceEntity, targetEntities);
                inserts = _diffLinks(existing, jointEntities, targetEntities, options);
                if (inserts == false) {
                    return false;
                }

                if (inserts && !_saveTarget(sourceEntity, inserts, options)) {
                    return false;
                }

                property = getProperty();

                if (count(inserts)) {
                    inserted = array_combine(
                        inserts.keys,
                        (array)sourceEntity.get(property)
                   ) ?: [];
                    targetEntities = inserted + targetEntities;
                }

                ksort(targetEntities);
                sourceEntity.set(property, array_values(targetEntities));
                sourceEntity.setDirty(property, false);

                return true;
            }
       );
    }

    /**
     * Helper method used to delete the difference between the links passed in
     * `existing` and `jointEntities`. This method will return the values from
     * `targetEntities` that were not deleted from calculating the difference.
     *
     * @param DORMQuery existing a query for getting existing links
     * @param array<DORMDatasource\IORMEntity> jointEntities link entities that should be persisted
     * @param Json[string] targetEntities entities in target table that are related to
     * the `jointEntities`
     * @param Json[string] options list of options accepted by `Table.remove()`
     * @return array|false Array of entities not deleted or false in case of deletion failure for atomic saves.
     */
    protected function _diffLinks(
        Query existing,
        array jointEntities,
        array targetEntities,
        Json[string] options = null
   ) {
        junction = this.junction();
        target = getTarget();
        belongsTo = junction.getAssociation(target.aliasName());
        foreignKeys = (array)foreignKeys();
        assocForeignKey = (array)belongsTo.foreignKeys();

        keys = array_merge(foreignKeys, assocForeignKey);
        deletes = unmatchedEntityKeys = present = null;

        foreach (jointEntities as i: entity) {
            unmatchedEntityKeys[i] = entity.extract(keys);
            present[i] = array_values(entity.extract(assocForeignKey));
        }

        foreach (existing as existingLink) {
            existingKeys = existingLink.extract(keys);
            found = false;
            foreach (unmatchedEntityKeys as i: unmatchedKeys) {
                matched = false;
                foreach (keys as key) {
                    if (is_object(unmatchedKeys[key]) && is_object(existingKeys[key])) {
                        // If both sides are an object then use == so that value objects
                        // are seen as equivalent.
                        matched = existingKeys[key] == unmatchedKeys[key];
                    } else {
                        // Use strict equality for all other values.
                        matched = existingKeys[key] == unmatchedKeys[key];
                    }
                    // Stop checks on first failure.
                    if (!matched) {
                        break;
                    }
                }
                if (matched) {
                    // Remove the unmatched entity so we don"t look at it again.
                    remove(unmatchedEntityKeys[i]);
                    found = true;
                    break;
                }
            }

            if (!found) {
                deletes ~= existingLink;
            }
        }

        auto primary = (array)target.primaryKeys();
        auto jointProperty = _junctionProperty;
        foreach (k, entity; targetEntities) {
            if (!cast(IORMEntity)entity) {
                continue;
            }
            auto key = array_values(entity.extract(primary));
            foreach (i, data; present) {
                if (key == data && !entity.get(jointProperty)) {
                    remove(targetEntities[k], present[i]);
                    break;
                }
            }
        }

        foreach (entity; deletes) {
            if (!junction.remove(entity, options) && !options.isEmpty("atomic"])) {
                return false;
            }
        }

        return targetEntities;
    }

    /**
     * Throws an exception should any of the passed entities is not persisted.
     *
     * @param DORMDatasource\IORMEntity sourceEntity the row belonging to the `source` side
     *  of this association
     * @param array<DORMDatasource\IORMEntity> targetEntities list of entities belonging to the `target` side
     *  of this association
     */
    protected bool _checkPersistenceStatus(IORMEntity sourceEntity, Json[string] targetEntities) {
        if (sourceEntity.isNew()) {
            error = "Source entity needs to be persisted before links can be created or removed.";
            throw new DInvalidArgumentException(error);
        }

        foreach (targetEntities as entity) {
            if (entity.isNew()) {
                error = "Cannot link entities that have not been persisted yet.";
                throw new DInvalidArgumentException(error);
            }
        }

        return true;
    }

    /**
     * Returns the list of joint entities that exist between the source entity
     * and each of the passed target entities
     *
     * @param DORMDatasource\IORMEntity sourceEntity The row belonging to the source side
     *  of this association.
     * @param Json[string] targetEntities The rows belonging to the target side of this
     *  association.
     */
    protected IORMEntity[] _collectJointEntities(IORMEntity sourceEntity, Json[string] targetEntities) {
        auto target = getTarget();
        auto source = source();
        auto junction = this.junction();
        auto jointProperty = _junctionProperty;
        auto primary = (array)target.primaryKeys();

        auto result = null;
        auto missing = null;

        foreach (entity; targetEntities) {
            if (!cast(IORMEntity)entity) {
                continue;
            }
            joint = entity.get(jointProperty);

            if (!joint || !cast(IORMEntity)joint)) {
                missing ~= entity.extract(primary);
                continue;
            }

            result ~= joint;
        }

        if (missing.isEmpty) {
            return result;
        }

        belongsTo = junction.getAssociation(target.aliasName());
        hasMany = source.getAssociation(junction.aliasName());
        foreignKeys = (array)foreignKeys();
        foreignKeys = array_map(function (key) {
            return key ~ " IS";
        }, foreignKeys);
        assocForeignKey = (array)belongsTo.foreignKeys();
        assocForeignKey = array_map(function (key) {
            return key ~ " IS";
        }, assocForeignKey);
        sourceKey = sourceEntity.extract((array)source.primaryKeys());

        unions = null;
        foreach (missing as key) {
            unions ~= hasMany.find()
                .where(array_combine(foreignKeys, sourceKey))
                .where(array_combine(assocForeignKey, key));
        }

        query = array_shift(unions);
        foreach (unions as q) {
            query.union(q);
        }

        return array_merge(result, query.toJString());
    }

    /**
     * Returns the name of the association from the target table to the junction table,
     * this name is used to generate alias in the query and to later on retrieve the
     * results.
     */
    protected string _junctionAssociationName() {
        if (!_junctionAssociationName) {
            _junctionAssociationName = getTarget()
                .getAssociation(this.junction().aliasName())
                .getName();
        }

        return _junctionAssociationName;
    }

    /**
     * Sets the name of the junction table.
     * If no arguments are passed the current configured name is returned. A default
     * name based of the associated tables will be generated if none found.
     */
    protected string _junctionTableName(string tableName = null) {
        if (tableName.isNull) {
            if (_junctionTableName.isEmpty) {
                tablesNames = array_map("uim\Utility\Inflector.underscore", [
                    source().getTable(),
                    getTarget().getTable(),
                ])().sort;
                _junctionTableName = tablesNames.join("_");
            }

            return _junctionTableName;
        }

        return _junctionTableName = tableName;
    }

    // Parse extra options passed in the constructor.
    protected void _options(Json[string] options = null) {
        if (!options.isEmpty("targetForeignKey")) {
            tarforeignKeys(options["targetForeignKey"]);
        }
        if (!options.isEmpty("joinTable")) {
            _junctionTableName(options["joinTable"]);
        }
        if (!options.isEmpty("through")) {
            setThrough(options["through"]);
        }
        if (!options.isEmpty("saveStrategy")) {
            setSaveStrategy(options["saveStrategy"]);
        }
        if (options.hasKey("sort")) {
            sortOrder(options["sort"]);
        }
    }
}
mixin(AssociationCalls!("BelongsToMany"));
