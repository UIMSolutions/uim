/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.classes.associations.hasmany;

import uim.orm;

@safe:

/**
 * Represents an N - 1 relationship where the target side of the relationship
 * will have one or multiple records per each one in the source side.
 *
 * An example of a HasMany association would be Author has many Articles.
 */
class DHasManyAssociation : DAssociation {
    mixin(AssociationThis!("HasMany"));

    // Saving strategy that will only append to the links set
    const string SAVE_APPEND = "append";

    // Saving strategy that will replace the links with the provided set
    const string SAVE_REPLACE = "replace";
    /**
     * DOrder in which target records should be returned
    /**
     * DOrder in which target records should be returned
     *
     * @var \UIM\Database\IExpression|\Closure|array<\UIM\Database\IExpression|string>|string
     */
    // TODO protected IExpression|Closure|string[] _sort = null;

    /**
     * The type of join to be used when adding the association to a query
     */
    protected string _joinType = Query.JOIN_TYPE_INNER;

    // The strategy name to be used to fetch associated records.
    protected string _strategy = self.STRATEGY_SELECT;

    // Valid strategies for this type of association
    protected string[] _validStrategies = [
        self.STRATEGY_SELECT,
        self.STRATEGY_SUBQUERY,
    ];

    // Saving strategy to be used by this association
    protected string _saveStrategy = self.SAVE_APPEND;

    /**
     * Returns whether the passed table is the owning side for this
     * association. This means that rows in the "target" table would miss important
     * or required information if the row in "source" did not exist.
     *
     * @param DORMTable side The potential Table with ownership
     */
    bool isOwningSide(Table side) {
        return side == source();
    }

    /**
     * Sets the strategy that should be used for saving.
     *
     * @param string strategy the strategy name to be used
     * @throws \InvalidArgumentException if an invalid strategy name is passed
     */
    void setSaveStrategy(string strategy) {
        if (!in_array(strategy, [self.SAVE_APPEND, self.SAVE_REPLACE], true)) {
            msg = sprintf("Invalid save strategy '%s'", strategy);
            throw new DInvalidArgumentException(msg);
        }

        _saveStrategy = strategy;
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
     * @param DORMDatasource\IORMEntity anEntity an entity from the source table
     * @param Json[string] options options to be passed to the save method in the target table
     * @return DORMDatasource\IORMEntity|false false if entity could not be saved, otherwise it returns
     * the saved entity
     * @throws \InvalidArgumentException when the association data cannot be traversed.
     */
    function saveAssociated(IORMEntity anEntity, Json[string] options = null) {
        myTargetEntities = entity.get(getProperty());

        isEmpty = in_array(myTargetEntities, [null, [], "", false], true);
        if (isEmpty) {
            if (
                entity.isNew() ||
                getSaveStrategy() != self.SAVE_REPLACE
                ) {
                return entity;
            }

            myTargetEntities = null;
        }

        if (!is_iterable(myTargetEntities)) {
            myName = getProperty();
            myMessage = "Could not save %s, it cannot be traversed".format(myName);
            throw new DInvalidArgumentException(myMessage);
        }

        foreignKeyReference = array_combine(
            (array) foreignKeys(),
            entity.extract((array) getBindingKey())
        );

        options["_sourceTable"] = source();

        if (
            _saveStrategy == self.SAVE_REPLACE &&
            !_unlinkAssociated(foreignKeyReference, entity, getTarget(), myTargetEntities, options)
            ) {
            return false;
        }

        if (!myTargetEntities.isArray) {
            myTargetEntities = iterator_to_array(myTargetEntities);
        }
        if (!_saveTarget(foreignKeyReference, entity, myTargetEntities, options)) {
            return false;
        }

        return entity;
    }

    /**
     * Persists each of the entities into the target table and creates links between
     * the parent entity and each one of the saved target entities.
     *
     * @param Json[string] foreignKeyReference The foreign key reference defining the link between the
     * target entity, and the parent entity.
     * @param DORMDatasource\IORMEntity parentEntity The source entity containing the target
     * entities to be saved.
     * @param Json[string] entities list of entities
     * to persist in target table and to link to the parent entity
     * @param Json[string] options list of options accepted by `Table.save()`.
     */
    protected bool _saveTarget(
        array foreignKeyReference,
        IORMEntity parentEntity,
        array entities,
        Json[string] options
    ) {
        foreignKey = foreignKeyReference.keys;
        myTable = getTarget();
        original = entities;
        foreach (entities as k : entity) {
            if (!(entity instanceof IORMEntity)) {
                break;
            }

            if (!options.isEmpty("atomic")) {
                entity = clone entity;
            }

            if (foreignKeyReference != entity.extract(foreignKey)) {
                entity.set(foreignKeyReference, [
                        "guard": false
                    ]);
            }

            if (myTable.save(entity, options)) {
                entities[k] = entity;
                continue;
            }

            if (!options.isEmpty("atomic")) {
                original[k].setErrors(entity.getErrors());
                if (entity instanceof IInvalidProperty) {
                    original[k].setInvalid(
                        entity.invalidFields());
                }

                return false;
            }
        }

        parentEntity.set(getProperty(), entities);

        return true;
    }

    /**
     * Associates the source entity to each of the target entities provided.
     * When using this method, all entities in `myTargetEntities` will be appended to
     * the source entity"s property corresponding to this association object.
     *
     * This method does not check link uniqueness.
     * Changes are persisted in the database and also in the source entity.
     *
     * ### Example:
     *
     * ```
     * myUser = myUsers.get(1);
     * allArticles = articles.find("all").toJString();
     * myUsers.Articles.link(myUser, allArticles);
     * ```
     *
     * `myUser.get("articles")` will contain all articles in `allArticles` after linking
     *
     * @param DORMDatasource\IORMEntity sourceEntity the row belonging to the `source` side
     * of this association
     * @param Json[string] myTargetEntities list of entities belonging to the `target` side
     * of this association
     * @param Json[string] options list of options to be passed to the internal `save` call
     */
    bool link(IORMEntity sourceEntity, Json[string] myTargetEntities, Json[string] options = null) {
        saveStrategy = getSaveStrategy();
        setSaveStrategy(self.SAVE_APPEND);
        property = getProperty();

        currentEntities = array_unique(
            array_merge(
                (array) sourceEntity.get(property),
                myTargetEntities
        )
        );
        sourceEntity.set(property, currentEntities);

        savedEntity = getConnection().transactional(
            function() use(sourceEntity, options) {
            return _saveAssociated(sourceEntity, options);});
            ok = (
                savedEntity instanceof IORMEntity);

            setSaveStrategy(saveStrategy);

            if (ok) {
                sourceEntity.set(property, savedEntity.get(
                    property));
                sourceEntity.setDirty(property, false);
            }

            return ok;
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
     * - cleanProperty: Whether to remove all the objects in `myTargetEntities` that
     * are stored in `sourceEntity` (default: true)
     *
     * By default this method will unset each of the entity objects stored inside the
     * source entity.
     *
     * Changes are persisted in the database and also in the source entity.
     *
     * ### Example:
     *
     * ```
     * myUser = myUsers.get(1);
     * myUser.articles = [article1, article2, article3, article4];
     * myUsers.save(myUser, ["Associated":["Articles"]]);
     * allArticles = [article1, article2, article3];
     * myUsers.Articles.unlink(myUser, allArticles);
     * ```
     *
     * `article.get("articles")` will contain only `[article4]` after deleting in the database
     *
     * @param DORMDatasource\IORMEntity sourceEntity an entity persisted in the source table for
     * this association
     * @param Json[string] myTargetEntities list of entities persisted in the target table for
     * this association
     * @param Json[string]|bool options list of options to be passed to the internal `delete` call.
     *   If boolean it will be used a value for "cleanProperty" option.
     * @throws \InvalidArgumentException if non persisted entities are passed or if
     * any of them is lacking a primary key value
     */
        void unlink(IORMEntity sourceEntity, Json[string] myTargetEntities, options = null) {
            if (is_bool(options)) {
                options = [
                    "cleanProperty": options,
                ];
            } else {
                auto updatedOptions = options
                    .update["cleanProperty": true];
            }
            if (count(myTargetEntities) == 0) {
                return;
            }

            foreignKey = (array) foreignKeys();
            myTarget = getTarget();
            myTargetPrimaryKey = array_merge(
                (array) myTarget.primaryKeys(), foreignKey);
            property = getProperty();

            conditions = [
                "OR": (new DCollection(
                        myTargetEntities))
                .map(
                    function(entity) use(
                        myTargetPrimaryKey) {
                    /** @var DORMdatasources.IORMEntity anEntity */
                    return entity.extract(
                        myTargetPrimaryKey);})
                        .toList(),];
                    _unlink(foreignKey, myTarget, conditions, options);

                    myResult = sourceEntity.get(
                        property);
                    if (options["cleanProperty"] && myResult !is null) {
                        sourceEntity.set(
                            property,
                            (new DCollection(
                            sourceEntity.get(property)))
                            .reject(
                            function(assoc) use(
                            myTargetEntities) {
                                return in_array(assoc, myTargetEntities);}
                                )
                                .toList()
                                );
                            }

                        sourceEntity.setDirty(property, false);
                    }

                    /**
     * Replaces existing association links between the source entity and the target
     * with the ones passed. This method does a smart cleanup, links that are already
     * persisted and present in `myTargetEntities` will not be deleted, new links will
     * be created for the passed target entities that are not already in the database
     * and the rest will be removed.
     *
     * For example, if an author has many articles, such as "article1","article 2" and "article 3" and you pass
     * to this method an array containing the entities for articles "article 1" and "article 4",
     * only the link for "article 1" will be kept in database, the links for "article 2" and "article 3" will be
     * deleted and the link for "article 4" will be created.
     *
     * Existing links are not deleted and created again, they are either left untouched
     * or updated.
     *
     * This method does not check link uniqueness.
     *
     * On success, the passed `sourceEntity` will contain `myTargetEntities` as value
     * in the corresponding property for this association.
     *
     * Additional options for new links to be saved can be passed in the third argument,
     * check `Table.save()` for information on the accepted options.
     *
     * ### Example:
     *
     * ```
     * author.articles = [article1, article2, article3, article4];
     * authors.save(author);
     * articles = [article1, article3];
     * authors.getAssociation("articles").replace(author, articles);
     * ```
     *
     * `author.get("articles")` will contain only `[article1, article3]` at the end
     *
     * @param DORMDatasource\IORMEntity sourceEntity an entity persisted in the source table for
     * this association
     * @param Json[string] myTargetEntities list of entities from the target table to be linked
     * @param Json[string] options list of options to be passed to the internal `save`/`delete` calls
     * when persisting/updating new links, or deleting existing ones
     * @throws \InvalidArgumentException if non persisted entities are passed or if
     * any of them is lacking a primary key value
     */
                    bool replace(IORMEntity sourceEntity, Json[string] myTargetEntities, Json[string] options = null) {
                        property = getProperty();
                        sourceEntity.set(property, myTargetEntities);
                        saveStrategy = getSaveStrategy();
                        setSaveStrategy(
                            self.SAVE_REPLACE);
                        myResult = this.saveAssociated(
                            sourceEntity, options);
                        ok = (
                            myResult instanceof IORMEntity);

                        if (ok) {
                            sourceEntity = myResult;
                        }
                        setSaveStrategy(
                            saveStrategy);

                        return ok;
                    }

                    /**
     * Deletes/sets null the related objects according to the dependency between source and targets
     * and foreign key nullability. Skips deleting records present in remainingEntities
     *
     * @param Json[string] foreignKeyReference The foreign key reference defining the link between the
     * target entity, and the parent entity.
     * @param DORMDatasource\IORMEntity anEntity the entity which should have its associated entities unassigned
     * @param DORMTable myTarget The associated table
     * @param range remainingEntities Entities that should not be deleted
     * @param Json[string] options list of options accepted by `Table.remove()`
     */
                    protected bool _unlinkAssociated(
                        array foreignKeyReference,
                        IORMEntity anEntity,
                        Table myTarget,
                        range remainingEntities = null,
                        Json[string] options = null
                    ) {
                        primaryKeys = (array) myTarget.primaryKeys();
                        exclusions = new DCollection(
                            remainingEntities);
                        exclusions = exclusions.map(
                            function(ent) use(
                            primaryKeys) {
                            /** @var DORMdatasources.IORMEntity ent */
                            return ent.extract(
                            primaryKeys);}
                            )
                            .filter(
                            function(v) { return !in_array(null, v, true); }
                            )
                            .toList();

                            conditions = foreignKeyReference;

                            if (
                                count(exclusions) > 0) {
                                conditions = [
                                    "NOT": [
                                        "OR": exclusions,
                                    ],
                                    foreignKeyReference,
                                ];
                            }

                            return _unlink(foreignKeyReference.keys, myTarget, conditions, options);
                        }

                        /**
     * Deletes/sets null the related objects matching conditions.
     *
     * The action which is taken depends on the dependency between source and
     * targets and also on foreign key nullability.
     *
     * @param Json[string] foreignKey array of foreign key properties
     * @param DORMTable myTarget The associated table
     * @param Json[string] conditions The conditions that specifies what are the objects to be unlinked
     * @param Json[string] options list of options accepted by `Table.remove()`
     */
                        protected bool _unlink(Json[string] foreignKey, Table myTarget, Json[string] conditions = null, Json[string] options = null) {
                            mustBeDependent = (!_foreignKeyAcceptsNull(
                                myTarget, foreignKey) || getDependent());

                            if (mustBeDependent) {
                                if (
                                    _cascadeCallbacks) {
                                    conditions = new DQueryExpression(
                                        conditions);
                                    conditions.traverse(
                                        void(
                                        entry) use(
                                        myTarget) {
                                        if (entry instanceof FieldInterface) {
                                            myField = entry
                                            .getField(); if (
                                                myField
                                            .isString) {
                                                entry.setField(
                                                myTarget
                                                .aliasField(
                                                myField));}
                                            }
                                        });
                                        myQuery = this.find()
                                        .where(
                                        conditions);
                                        ok = true;
                                        foreach (
                                            myQuery as assoc) {
                                            ok = ok && myTarget.remove(
                                            assoc, options);
                                        }

                                        return ok;
                                    }

                                    this.deleteAll(
                                        conditions);

                                    return true;
                                }

                                updateFields = array_fill_keys(foreignKey, null);
                                this.updateAll(updateFields, conditions);

                                return true;
                            }

                            /**
     * Checks the nullable flag of the foreign key
     *
     * @param DORMTable myTable the table containing the foreign key
     * @param Json[string] properties the list of fields that compose the foreign key
     */
                            protected bool _foreignKeyAcceptsNull(Table myTable, Json[string] properties) {
                                return !in_array(
                                    false,
                                    array_map(
                                    function(prop) use(
                                    myTable) {
                                        return myTable.getSchema()
                                        .isNullable(prop);},
                                        properties
                                        )
                                        );
                                    }

                                /**
     * Get the relationship type.
     */
                                string type() {
                                    return self.ONE_TO_MANY;
                                }

                                /**
     * Whether this association can be expressed directly in a query join
     *
     * @param Json[string] options custom options key that could alter the return value
     * @return bool if the "matching" key in option is true then this function
     * will return true, false otherwise
     */
                                bool canBeJoined(
                                    Json[string] options = null) {
                                    return !options.isEmpty(
                                        "matching"]);
                                }

                                // Gets the name of the field representing the foreign key to the source table.
                                string[] foreignKeys() {
                                    if (_foreignKey.isNull) {
                                        _foreignKey = _modelKey(source()
                                            .getTable());
                                    }

                                    return _foreignKey;
                                }

                                /**
     * Sets the sort order in which target records should be returned.
     *
     * @param mixed sort A find() compatible order clause
     */
                                void sortOrder(sort) {
                                    _sort = sort;
                                }

                                // Gets the sort order in which target records should be returned.
                                Json sortOrder() {
                                    return _sort;
                                }

                                array defaultRowValue(Json[string] row, bool joined) {
                                    sourceAlias = source().aliasName();
                                    if (isset(
                                        row[sourceAlias])) {
                                        row[sourceAlias][getProperty()] = joined ? null : [
                                        ];
                                    }

                                    return row;
                                }

                                /**
     * Parse extra options passed in the constructor.
     *
     * @param Json[string] options original list of options passed in constructor
     */
                                protected void _options(
                                    Json[string] options) {
                                    if (!options.isEmpty(
                                        "saveStrategy")) {
                                        setSaveStrategy(
                                            options["saveStrategy"]);
                                    }
                                    if (isset(
                                        options["sort"])) {
                                        sortOrder(
                                            options["sort"]);
                                    }
                                }

                                Closure eagerLoader(
                                    Json[string] options) {
                                    auto loader = new DSelectLoader(
                                        [
                                        "alias": aliasName(),
                                        "sourceAlias": source().aliasName(),
                                        "targetAlias": getTarget()
                                        .aliasName(),
                                        "foreignKey": foreignKeys(),
                                        "bindingKey": getBindingKey(),
                                        "strategy": getStrategy(),
                                        "associationType": associationType(),
                                        "sort": getSort(),
                                        "finder": [
                                            this,
                                            "find"
                                        ],
                                    ]);
                                    return loader.buildEagerLoader(
                                        options);
                                }

                                bool cascaderemove(IORMEntity anEntity, Json[string] options = null) {
                                    helper = new DependentDeleteHelper();

                                    return helper.cascaderemove(this, entity, options);
                                }
                            }
                            mixin(AssociationCalls!(
                                "HasMany"));
