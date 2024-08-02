module uim.orm.classes.eagerloader;

import uim.orm;

@safe:

/**
 * Exposes the methods for storing the associations that should be eager loaded
 * for a table once a query is provided and delegates the job of creating the
 * required joins and decorating the results so that those associations can be
 * part of the result set.
 */
class DEagerLoader {
  /**
     * Nested array describing the association to be fetched
     * and the options to apply for each of them, if any
     */
  protected Json[string] _containments = null;

  // #region AutoFieldEnabled
    /++
          + Controls whether fields from associated tables will be eagerly loaded. 
          + When set to false, no fields will be loaded from associations.
          +/
    protected bool _autoFields = true;

    // Sets whether contained associations will load fields automatically.
    void enableAutoFields(bool enable = true) {
      _autoFields = enable;
    }

    // Disable auto loading fields of contained associations.
    void disableAutoFields() {
      _autoFields = false;
    }

    // Gets whether contained associations will load fields automatically.
    bool isAutoFieldsEnabled() {
      return _autoFields;
    }
  // #endregion AutoFieldEnabled

  /**
     * Contains a nested array with the compiled containments tree
     * This is a normalized version of the user provided containments array.
     *
     * @var DORMEagerLoadable|array<DORMEagerLoadable>|null
     */
    protected _normalized;

    /**
     * List of options accepted by associations in contain()
     * index by key for faster access
     */
    protected int[string]_containOptions = [
        "associations": 1,
        "foreignKeys": 1,
        "conditions": 1,
        "fields": 1,
        "sort": 1,
        "matching": 1,
        "queryBuilder": 1,
        "finder": 1,
        "joinType": 1,
        "strategy": 1,
        "negateMatch": 1,
    ];

    /**
     * A list of associations that should be loaded with a separate query
     *
     * @var array<DORMEagerLoadable>
     */
    protected _loadExternal = null;

    /**
     * Contains a list of the association names that are to be eagerly loaded
     *
     * @var array
     */
    protected _aliasList = null;

    // Another EagerLoader instance that will be used for "matching" associations.
    protected DORMEagerLoader _matching;

    /**
     * A map of table aliases pointing to the association objects they represent
     * for the query
     */
    protected DORMEagerLoadable[string] _joinsMap = null;



    /**
     * Sets the list of associations that should be eagerly loaded along for a
     * specific table using when a query is provided. The list of associated tables
     * passed to this method must have been previously set as associations using the
     * Table API.
     *
     * Associations can be arbitrarily nested using dot notation or nested arrays,
     * this allows this object to calculate joins or any additional queries that
     * must be executed to bring the required associated data.
     *
     * Accepted options per passed association:
     *
     * - foreignKeys: Used to set a different field to match both tables, if set to false
     *  no join conditions will be generated automatically
     * - fields: An array with the fields that should be fetched from the association
     * - queryBuilder: Equivalent to passing a callable instead of an options array
     * - matching: Whether to inform the association class that it should filter the
     * main query by the results fetched by that class.
     * - joinType: For joinable associations, the SQL join type to use.
     * - strategy: The loading strategy to use (join, select, subquery)
     *
     */
    Json[string] contain(/* array| */string associations, callable queryBuilder = null) {
        if (queryBuilder) {
            if (!associations.isString) {
                throw new DInvalidArgumentException(
                    "Cannot set containments. To use queryBuilder, associations must be a string"
               );
            }

            associations = [
                associations: [
                    "queryBuilder": queryBuilder,
                ],
            ];
        }

        associations = /* (array) */associations;
        associations = _reformatContain(associations, _containments);
        _normalized = null;
        _loadExternal = null;
        _aliasList = null;

        return _containments = associations;
    }

    /**
     * Gets the list of associations that should be eagerly loaded along for a
     * specific table using when a query is provided. The list of associated tables
     * passed to this method must have been previously set as associations using the Table API.
     */
    Json[string] getContain() {
        return _containments;
    }

    /**
     * Remove any existing non-matching based containments.
     *
     * This will reset/clear out any contained associations that were not
     * added via matching().
     */
    void clearContain() {
        _containments = null;
        _normalized = null;
        _loadExternal = null;
        _aliasList = null;
    }
 
    /**
     * Adds a new association to the list that will be used to filter the results of
     * any given query based on the results of finding records for that association.
     * You can pass a dot separated path of associations to this method as its first
     * parameter, this will translate in setting all those associations with the
     * `matching` option.
     *
     * ### Options
     *
     * - `joinType`: INNER, OUTER, ...
     * - `fields`: Fields to contain
     * - `negateMatch`: Whether to add conditions negate match on target association
     */
    void setMatching(string associationPath, callable builder = null, Json[string] options = null) {
        if (_matching == null) {
            _matching = new static();
        }

        auto updatedOptions = options.setPath(["joinType": Query.JOIN_TYPE_INNER]);
        auto sharedOptions = ["negateMatch": false.toJson, "matching": true.toJson] + options;

        auto contains = null;
        nested = &contains;
        foreach (association; explode(".", associationPath)) {
            // Add contain to parent contain using association name as key
            nested[association] = sharedOptions;
            // Set to next nested level
            nested = &nested[association];
        }

        // Add all options to target association contain which is the last in nested chain
        nested = ["matching": true.toJson, "queryBuilder": builder] + options;
        _matching.contain(contains);
    }

    // Returns the current tree of associations to be matched.
    Json[string] getMatching() {
        if (_matching == null) {
            _matching = new static();
        }

        return _matching.getContain();
    }

    /**
     * Returns the fully normalized array of associations that should be eagerly
     * loaded for a table. The normalized array will restructure the original array
     * by sorting all associations under one key and special options under another.
     *
     * Each of the levels of the associations tree will be converted to a {@link DORMEagerLoadable}
     * object, that contains all the information required for the association objects
     * to load the information from the database.
     *
     * Additionally, it will set an "instance" key per association containing the
     * association instance from the corresponding source table
     */
    auto normalized(DORMTable repository) {
        if (_normalized != null || _containments.isEmpty) {
            return /* (array) */_normalized;
        }

        contain = null;
        foreach (aliasName,  options; _containments) {
            if (options.hasKey("instance")) {
                contain = _containments;
                break;
            }
            contain[aliasName] = _normalizeContain(
                repository, aliasName, options,
                ["root": Json(null)]
           );
        }

        return _normalized = contain;
    }

    /**
     * Formats the containments array so that associations are always set as keys
     * in the array. This function merges the original associations array with
     * the new associations provided
     */
    protected Json[string] _reformatContain(Json[string] associations, Json[string] originalContainments) {
        auto result = originalContainments;

        foreach (table, options; associations) {
            pointer = &result;
            if (isInteger(table)) {
                table = options;
                options = null;
            }

            if (cast(EagerLoadable)options) {
                options = options.asContainArray();
                string table = key(options);
                options = currentValue(options);
            }

            if (_containOptions.hasKey(table)) {
                pointer.set(table, options);
                continue;
            }

            if (table.contains(".")) {
                auto path = explode(".", table);
                auto table = path.pop();
                foreach (t; path) {
                    pointer += [t: []];
                    pointer = &pointer[t];
                }
            }

            if (options.isArray) {
                options = options.hasKey("config") ?
                    options.get("config"] + options.get("associations"] :
                    options;
                options = _reformatContain(
                    options,
                    pointer.getArray(table)
               );
            }

            if (cast(DClosure)options) {
                options = ["queryBuilder": options];
            }

            pointer += [table: []];

            if (options.hasKey("queryBuilder") && pointer.hasKey(table, "queryBuilder")) {
                auto first = pointer[table]["queryBuilder"];
                auto second = options.get("queryBuilder");
               /* options.get("queryBuilder"] = function (query) use (first, second) {
                    return second(first(query));
                }; */
            }

            if (!options.isArray) {
                /** @psalm-suppress InvalidArrayOffset */
                options = [options: []];
            }

            pointer.set(table, options + pointer[table];
        }

        return result;
    }

    /**
     * Modifies the passed query to apply joins or any other transformation required
     * in order to eager load the associations described in the `contain` array.
     * This method will not modify the query for loading external associations, i.e.
     * those that cannot be loaded without executing a separate query.
     */
    void attachAssociations(DORMQuery query, DORMTable repository, bool includeFields) {
        if (_containments.isEmpty && _matching == null) {
            return;
        }

        auto attachable = attachableAssociations(repository);
        auto processed = null;
        do {
            foreach (attachable as aliasName: loadable) {
                myConfiguration = loadable.configuration.data + [
                    "aliasPath": loadable.aliasPath(),
                    "propertyPath": loadable.propertyPath(),
                    "includeFields": includeFields,
                ];
                loadable.instance().attachTo(query, myConfiguration);
                processed[aliasName] = true;
            }

            newAttachable = attachableAssociations(repository);
            attachable = array_diffinternalKey(newAttachable, processed);
        } while (!attachable.isEmpty);
    }

    /**
     * Returns an array with the associations that can be fetched using a single query,
     * the array keys are the association aliases and the values will contain an array
     * with uim\orm.EagerLoadable objects.
     */
    DORMEagerLoadable[] attachableAssociations(DORMTable repository) {
        auto contain = this.normalized(repository);
        auto matching = _matching ? _matching.normalized(repository) : [];
        _fixStrategies();
        _loadExternal = null;

        return _resolveJoins(contain, matching);
    }

    /**
     * Returns an array with the associations that need to be fetched using a
     * separate query, each array value will contain a {@link DORMEagerLoadable} object.
     */
    DORMEagerLoadable[] externalAssociations(DORMTable repository) {
        if (_loadExternal) {
            return _loadExternal;
        }

        attachableAssociations(repository);

        return _loadExternal;
    }

    // Auxiliary function responsible for fully normalizing deep associations defined using `contain()`
    protected DEagerLoadable _normalizeContain(DORMTable parent, string aliasName, Json[string] options, Json[string] paths) {
        auto defaults = _containOptions;
        auto instance = parent.getAssociation(aliasName);

        paths += ["aliasPath": "", "propertyPath": "", "root": aliasName];
        paths["aliasPath").concat( "." ~ aliasName;

        if (
            options.hasKey("matching") &&
            options.get("matching") == true
       ) {
            paths["propertyPath"] = "_matchingData." ~ aliasName;
        } else {
            paths["propertyPath").concat( "." ~ instance.getProperty();
        }

        auto table = instance.getTarget();
        auto extra = array_diffinternalKey(options, defaults);
        myConfiguration = [
            "associations": Json.emptyArray,
            "instance": instance,
            "config": array_diffinternalKey(options, extra),
            "aliasPath": paths.getString("aliasPath").strip("."),
            "propertyPath": paths.getString("propertyPath").strip("."),
            "targetProperty": instance.getProperty(),
        ];
        configuration.set("canBeJoined", instance.canBeJoined(configuration.get("config")));
        eagerLoadable = new DEagerLoadable(aliasName, myConfiguration);

        if (configuration.hasKey("canBeJoined")) {
            _aliasList.add([paths.getString("root"), aliasName], eagerLoadable);
        } else {
            paths.set("root", configuration.get("aliasPath"));
        }

        foreach (t, association; extra) {
            eagerLoadable.addAssociation(
                t,
                _normalizeContain(table, t, association, paths)
           );
        }

        return eagerLoadable;
    }

    /**
     * Iterates over the joinable aliases list and corrects the fetching strategies
     * in order to avoid aliases collision in the generated queries.
     *
     * This function operates on the array references that were generated by the
     * _normalizeContain() function.
     */
    protected void _fixStrategies() {
        foreach (aliases; _aliasList) {
            foreach (configs; aliases) {
                if (count(configs) < 2) {
                    continue;
                }
                /** @var DORMEagerLoadable loadable */
                foreach (loadable; configs) {
                    if (indexOf(loadable.aliasPath(), ".")) {
                        _correctStrategy(loadable);
                    }
                }
            }
        }
    }

    /**
     * Changes the association fetching strategy if required because of duplicate
     * under the same direct associations chain
     */
    protected void _correctStrategy(DORMEagerLoadable loadable) {
        auto myConfiguration = loadable.configuration.data;
        auto currentStrategy = configuration.getString("strategy", "join");

        if (!loadable.canBeJoined() || currentStrategy != "join") {
            return;
        }

        configuration.set("strategy", Association.STRATEGY_SELECT);
        loadable.configuration.set(myConfiguration);
        loadable.setCanBeJoined(false);
    }

    /**
     * Helper function used to compile a list of all associations that can be joined in the query.
     */
    protected DORMEagerLoadable[] _resolveJoins(DORMEagerLoadable[] associations, DORMEagerLoadable[] matching = null) {
        auto result = null;
        foreach (matching as table: loadable) {
            result.set(table, loadable;
            result += _resolveJoins(loadable.associations(), []);
        }
        foreach (table, loadable; associations) {
            bool inMatching = matching.hasKey(table);
            if (!inMatching && loadable.canBeJoined()) {
                result.set(table, loadable;
                result += _resolveJoins(loadable.associations(), []);
                continue;
            }

            if (inMatching) {
                _correctStrategy(loadable);
            }

            loadable.setCanBeJoined(false);
            _loadExternal ~= loadable;
        }

        return result;
    }

    /**
     * Decorates the passed statement object in order to inject data from associations
     * that cannot be joined directly.
     */
    IStatement loadExternal(DORMQuery query, IStatement statement) {
        auto table = query.getRepository();
        auto external = this.externalAssociations(table);
        if (external.isEmpty) {
            return statement;
        }

        auto driver = query.getConnection().getDriver();
        [collected, statement] = _collectKeys(external, query, statement);

        // No records found, skip trying to attach associations.
        if (empty(collected) && statement.count() == 0) {
            return statement;
        }

        foreach (meta; external) {
            auto contain = meta.associations();
            auto instance = meta.instance();
            auto myConfiguration = meta.configuration.data;
            auto aliasName = instance.source().aliasName();
            auto path = meta.aliasPath();

            auto requiresKeys = instance.requiresKeys(myConfiguration);
            if (requiresKeys) {
                // If the path or aliasName has no key the required association load will fail.
                // Nested paths are not subject to this condition because they could
                // be attached to joined associations.
                if (
                    indexOf(path, ".") == false &&
                    (!array_key_hasKey(path, collected) || !array_key_hasKey(aliasName, collected[path]))
               ) {
                    message = "Unable to load `{path}` association. Ensure foreign key in `{aliasName}` is selected.";
                    throw new DInvalidArgumentException(message);
                }

                // If the association foreign keys are missing skip loading
                // as the association could be optional.
                if (collected.isEmpty([path, aliasName])) {
                    continue;
                }
            }

            auto keys = collected.get(path~"."~aliasName, null);
            auto f = instance.eagerLoader(
                myConfiguration + [
                    "query": query,
                    "contain": contain,
                    "keys": keys,
                    "nestKey": meta.aliasPath(),
                ]
           );
            statement = new DCallbackStatement(statement, driver, f);
        }

        return statement;
    }

    /**
     * Returns an array having as keys a dotted path of associations that participate
     * in this eager loader. The values of the array will contain the following keys
     *
     * - aliasName: The association aliasName
     * - instance: The association instance
     * - canBeJoined: Whether the association will be loaded using a JOIN
     * - entityClass: The entity that should be used for hydrating the results
     * - nestKey: A dotted path that can be used to correctly insert the data into the results.
     * - matching: Whether it is an association loaded through `matching()`.
     */
    array associationsMap(DORMTable aTable) {
        map = null;

        if (!getMatching() && !getContain() && empty(_joinsMap)) {
            return map;
        }

        /** @psalm-suppress PossiblyNullReference */
        map = _buildAssociationsMap(map, _matching.normalized(table), true);
        map = _buildAssociationsMap(map, this.normalized(table));

        return _buildAssociationsMap(map, _joinsMap);
    }

    /**
     * An internal method to build a map which is used for the return value of the
     * associationsMap() method.
     */
    protected Json[string] _buildAssociationsMap(Json[string] map, DORMEagerLoadable[] level, bool isMatching = false) {
        foreach (level as association: meta) {
            auto canBeJoined = meta.canBeJoined();
            auto instance = meta.instance();
            auto associations = meta.associations();
            auto forMatching = meta.forMatching();
            auto map ~= [
                "aliasName": association,
                "instance": instance,
                "canBeJoined": canBeJoined,
                "entityClass": instance.getTarget().getEntityClass(),
                "nestKey": canBeJoined ? association : meta.aliasPath(),
                "matching": forMatching ?? isMatching,
                "targetProperty": meta.targetProperty(),
            ];
            if (canBeJoined && associations) {
                map = _buildAssociationsMap(map, associations, isMatching);
            }
        }

        return map;
    }

    /**
     * Registers a table aliasName, typically loaded as a join in a query, as belonging to
     * an association. This helps hydrators know what to do with the columns coming
     * from such joined table.
     */
    void addToJoinsMap(
        string aliasName,
        DORMAssociation association,
        bool isMatching = false,
        string targetProperty = null
   ) {
        _joinsMap[aliasName] = new DEagerLoadable(aliasName, [
            "aliasPath": aliasName,
            "instance": association,
            "canBeJoined": true.toJson,
            "forMatching": isMatching,
            "targetProperty": targetProperty.ifEmpty(association.getProperty()),
        ]);
    }

    /**
     * Helper function used to return the keys from the query records that will be used
     * to eagerly load associations.
     */
    protected Json[string] _collectKeys(Json[string] external, DQuery query, IStatement statement) {
        auto collectKeys = null;
        foreach (meta; external) {
            auto instance = meta.instance();
            if (!instance.requiresKeys(meta.configuration.data)) {
                continue;
            }

            auto source = instance.source();
            auto keys = instance.type() == Association.MANY_TO_ONE ?
                /* (array) */instance.foreignKeys() :
                /* (array) */instance.getBindingKey();

            auto aliasName = source.aliasName();
            auto pkFields = null;
            foreach (key; keys) {
                pkFields ~= key(query.aliasField(key, aliasName));
            }
            collectKeys[meta.aliasPath()] = [aliasName, pkFields, count(pkFields) == 1];
        }
        if (collectKeys.isEmpty) {
            return [[], statement];
        }

        if (!cast(BufferedStatement)statement) {
            statement = new BufferedStatement(statement, query.getConnection().getDriver());
        }

        return [_groupKeys(statement, collectKeys), statement];
    }

    /**
     * Helper function used to iterate a statement and extract the columns
     * defined in collectKeys
     */
    protected Json[string] _groupKeys(BufferedStatement statement, Json[string] collectKeys) {
        auto keys = null;
        foreach (result; (statement.fetchAll("association") ?: [])) {
            foreach (nestKey, parts; collectKeys) {
                if (parts[2] == true) {
                    // Missed joins will have null in the results.
                    if (!array_key_hasKey(parts[1][0], result)) {
                        continue;
                    }
                    // Assign empty array to avoid not found association when optional.
                    if (result.isNull(parts[1][0])) {
                        if (aKeys.isNull([nestKey, parts[0]])) {
                            keys[nestKey][parts[0]] = null;
                        }
                    } else {
                        value = result[parts[1][0]];
                        keys[nestKey][parts[0]][value] = value;
                    }
                    continue;
                }

                // Handle composite keys.
                auto collected = null;
                foreach (key; parts[1]) {
                    collected ~= result[key];
                }
                keys[nestKey][parts[0]][collected.join(";")] = collected;
            }
        }
        statement.rewind();

        return keys;
    }

    // Handles cloning eager loaders and eager loadables
    void clone() {
        if (_matching) {
            _matching = _matching.clone;
        }
    }
}
