module uim.orm.classes.associations.eagerloader;

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

    /**
     * Controls whether fields from associated tables will be eagerly loaded.
     * When set to false, no fields will be loaded from associations.
     */
    protected bool _autoFields = true;

    /**
     * Contains a nested array with the compiled containments tree
     * This is a normalized version of the user provided containments array.
     *
     * @var \ORM\EagerLoadable|array<\ORM\EagerLoadable>|null
     */
    protected DEagerLoadable|array|null _normalized = null;

    /**
     * List of options accepted by associations in contain()
     * index by key for faster access.
     */
    protected int<string> _containOptions = [
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

    // A list of associations that should be loaded with a separate query.
    protected DEagerLoadable<> _loadExternal = null;

    // Contains a list of the association names that are to be eagerly loaded.
    protected Json[string] _aliasList = null;

    // Another EagerLoader instance that will be used for "matching" associations.
    protected DEagerLoader _matching = null;

    // A map of table aliases pointing to the association objects they represent for the query.
    // TODO protected array<string, \ORM\EagerLoadable> _joinsMap = null;


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
     * - `foreignKeys`: Used to set a different field to match both tables, if set to false
     * no join conditions will be generated automatically
     * - `fields`: An array with the fields that should be fetched from the association
     * - `queryBuilder`: Equivalent to passing a callback instead of an options array
     * - `matching`: Whether to inform the association class that it should filter the
     * main query by the results fetched by that class.
     * - `joinType`: For joinable associations, the SQL join type to use.
     * - `strategy`: The loading strategy to use (join, select, subquery)
     */
    array contain(string[] myassociations, Closure queryBuilderCallback = null) {
        if (queryBuilderCallback) {
            if (!isString(myassociations)) {
                throw new DInvalidArgumentException(
                    "Cannot set containments. To use myqueryBuilder, myassociations must be a string"
               );
            }
            myassociations = [
                myassociations: [
                    "queryBuilder": queryBuilderCallback,
                ],
            ];
        }
        myassociations = (array)myassociations;
        myassociations = _reformatContain(myassociations, _containments);
       _normalized = null;
       _loadExternal = null;
       _aliasList = null;

        return _containments = myassociations;
    }
    
    /**
     * Gets the list of associations that should be eagerly loaded along for a
     * specific table using when a query is provided. The list of associated tables
     * passed to this method must have been previously set as associations using the
     * Table API.
     */
    array getContain() {
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
     * Sets whether contained associations will load fields automatically.
     * Params:
     * bool myenable The value to set.
     */
    void enableAutoFields(bool myenable = true) {
       _autoFields = myenable;
    }
    
    /**
     * Disable auto loading fields of contained associations.
     */
    auto disableAutoFields() {
       _autoFields = false;

        return this;
    }
    
    /**
     * Gets whether contained associations will load fields automatically.
     */
    bool isAutoFieldsEnabled() {
        return _autoFields;
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
    void setMatching(string associationPath(, DClosure mybuilder = null, Json[string] options = null) {
       _matching ? _matching : new static();

        auto updatedOptions = options.update["joinType": SelectQuery.JOIN_TYPE_INNER];
        auto mysharedOptions = ["negateMatch": false.toJson, "matching": true.toJson] + options;

        auto mycontains = null;
        auto mynested = &mycontains;
        associationPath(.split(".")
            .each!((association) {
                // Add contain to parent contain using association name as key
                mynested[association] = mysharedOptions;
                // Set to next nested level
                mynested = &mynested[association];
            });
        // Add all options to target association contain which is the last in nested chain
        mynested = ["matching": true.toJson, "queryBuilder": mybuilder] + options;
       _matching.contain(mycontains);
    }
    
    // Returns the current tree of associations to be matched.
    array getMatching() {
       _matching = _matching : new static();

        return _matching.getContain();
    }
    
    /**
     * Returns the fully normalized array of associations that should be eagerly
     * loaded for a table. The normalized array will restructure the original array
     * by sorting all associations under one key and special options under another.
     *
     * Each of the levels of the associations tree will be converted to a {@link \ORM\EagerLoadable}
     * object, that contains all the information required for the association objects
     * to load the information from the database.
     *
     * Additionally, it will set an "instance" key per association containing the
     * association instance from the corresponding source table
     * Params:
     * \ORM\Table repository The table containing the association that
     * will be normalized.
     */
    array normalized(DORMTable repository) {
        if (_normalized !is null || _containments.isEmpty) {
            return /* (array) */_normalized;
        }
        mycontain = null;
        foreach (aliasName, options; _containments) {
            if (!options.isEmpty("instance"])) {
                mycontain = _containments;
                break;
            }
            mycontain[aliasName] = _normalizeContain(
                repository,
                aliasName,
                options,
                ["root": Json(null)]
           );
        }
        return _normalized = mycontain;
    }
    
    /**
     * Formats the containments array so that associations are always set as keys
     * in the array. This auto merges the original associations array with
     * the new associations provided.
     */
    protected Json[string] _reformatContain(Json[string] associations, Json[string] originalData) {
        auto result = originalData;

        foreach (ormtable,  options; associations) {
            auto mypointer = &result;
            string ormtable;
            if (isInteger(ormtable)) {
                ormtable = options;
                options = null;
            }
            if (cast(EagerLoadable)options) {
                options = options.asContainArray();
                ormtable = key(options);
                options = currentValue(options);
            }
            if (_containoptions.hasKey(ormtable))) {
                mypointer.set(ormtable, options);
                continue;
            }
            if (ormtable.contains(".")) {
                string[] mypath = ormtable.split(".");
                ormtable = array_pop(mypath);
                mypath.each!((t) {
                    mypointer += [t: []];
                    mypointer = &mypointer[t];
                });
            }
            if (isArray(options)) {
                options = options.hasKey("config") 
                    ? options.get("config") + options.get("associations") 
                    : options;
                options = _reformatContain(
                    options,
                    mypointer.get(ormtable)
               );
            }
            if (cast(DClosure)options) {
                options = ["queryBuilder": options];
            }
            mypointer += [ormtable: []];

            if (options.hasKey("queryBuilder"), mypointer[ormtable]["queryBuilder"]) {
                myfirst = mypointer[ormtable]["queryBuilder"];
                mysecond = options.get("queryBuilder");
                // TODO options.get("queryBuilder"] = fn (selectQuery): mysecond(myfirst(selectQuery));
            }
            if (!isArray(options)) {
                /** @psalm-suppress InvalidArrayOffset */
                options = [options: []];
            }
            mypointer[ormtable] = options + mypointer[ormtable];
        }
        return result;
    }
    
    /**
     * Modifies the passed query to apply joins or any other transformation required
     * in order to eager load the associations described in the `contain` array.
     * This method will not modify the query for loading external associations, i.e.
     * those that cannot be loaded without executing a separate query.
     */
    void attachAssociations(SelectQuery selectQuery, DORMTable repository, bool shouldAppendFields) {
        if (isEmpty(_containments) && _matching.isNull) {
            return;
        }
        
        auto myattachable = attachableAssociations(repository);
        auto myprocessed = null;
        do {
            foreach (aliasName, myloadable; myattachable) {
                configData = myloadable.configuration.data ~ [
                    "aliasPath": myloadable.aliasPath(),
                    "propertyPath": myloadable.propertyPath(),
                    "includeFields": shouldAppendFields,
                ];
                myloadable.instance().attachTo(selectQuery, configData);
                myprocessed[aliasName] = true;
            }
            mynewAttachable = attachableAssociations(repository);
            myattachable = array_diffinternalKey(mynewAttachable, myprocessed);
        } while (!myattachable.isEmpty);
    }
    
    /**
     * Returns an array with the associations that can be fetched using a single query,
     * the array keys are the association aliases and the values will contain an array
     * with UIM\ORM\EagerLoadable objects.
     */
    DEagerLoadable[] attachableAssociations(DORMTable repository) {
        auto mycontain = normalized(repository);
        auto mymatching = _matching ? _matching.normalized(repository): [];
       _fixStrategies();
       _loadExternal = null;

        return _resolveJoins(mycontain, mymatching);
    }
    
    /**
     * Returns an array with the associations that need to be fetched using a
     * separate query, each array value will contain a {@link \ORM\EagerLoadable} object.
     */
    EagerLoadable[] externalAssociations(DORMTable repository) {
        if (_loadExternal) {
            return _loadExternal;
        }
        attachableAssociations(repository);

        return _loadExternal;
    }
    
    // Auxiliary auto responsible for fully normalizing deep associations defined using `contain()`.
    protected DEagerLoadable _normalizeContain(DORMTable myparent, string aliasName, Json[string] options, Json[string] paths) {
        auto defaults = _containOptions;
        auto myinstance = myparent.getAssociation(aliasName);

        paths
            .merge("aliasPath", "")
            .merge("propertyPath", "")
            .merge("root", aliasName);

        paths.set("aliasPath", paths.getString("aliasPath") ~ "." ~ aliasName);

        paths.set("propertyPath",
            options.hasKey("matching") && options.get("matching") == true
            ? "_matchingData." ~ aliasName
            : paths.getString("propertyPath") ~ "." ~ myinstance.getProperty());
        }
        
        auto ormtable = myinstance.getTarget();
        Json[string] myextra = array_diffinternalKey(options, defaults);
        Json[string] configData = [
            "associations": Json.emptyArray,
            "instance": myinstance,
            "config": array_diffinternalKey(options, myextra),
            "aliasPath": paths.getString("aliasPath").strip("."),
            "propertyPath": paths.getString("propertyPath").strip("."),
            "targetProperty": myinstance.getProperty(),
        ];
        configuration.set("canBeJoined", myinstance.canBeJoined(configuration.get("config")));
        myeagerLoadable = new DEagerLoadable(aliasName, configData);

        if (configuration.hasKey("canBeJoined")) {
           _aliasList[paths.getString("root")][aliasName).concat( myeagerLoadable;
        } else {
            paths.set("root", configuration.get("aliasPath"));
        }
        myextra.byKeyValue
            .each!((tAssoc) {
                myeagerLoadable.addAssociation(
                    tAssoc.key,
                    _normalizeContain(ormtable, tAssoc.key, tAssoc.value, paths)
               );
            });
        return myeagerLoadable;
    }
    
    /**
     * Iterates over the joinable aliases list and corrects the fetching strategies
     * in order to avoid aliases collision in the generated queries.
     *
     * This auto operates on the array references that were generated by the
     * _normalizeContain() function.
     */
    protected void _fixStrategies() {
        foreach (myaliases; _aliasList) {
            myaliases
                .filter!(confifData => count(configData) > 1)
                .each!((configData) {
                    foreach (myloadable; configData) {
                        assert(cast(DEagerLoadable)myloadable);
                        if (myloadable.aliasPath().contains(".")) {
                        _correctStrategy(myloadable);
                        }
                    }
                });
        }
    }
    
    /**
     * Changes the association fetching strategy if required because of duplicate
     * under the same direct associations chain.
     */
    protected void _correctStrategy(DEagerLoadable myloadable) {
        auto configData = myloadable.configuration.data;
        string currentStrategy = configuration.getString("strategy", "join");

        if (!myloadable.canBeJoined() || currentStrategy != "join") {
            return;
        }
        configuration.set("strategy", Association.STRATEGY_SELECT);
        myloadable.configuration.set(configData);
        myloadable.setCanBeJoined(false);
    }
    
    /**
     * Helper auto used to compile a list of all associations that can be
     * joined in the query.
     * Params:
     * array<\ORM\> associations List of associations from which to obtain joins.
     */
    protected DEagerLoadable[] _resolveJoins(DEagerLoadable[] associations, DEagerLoadable[] mymatching = null) {
        DEagerLoadable[] result;
        foreach (ormtable, myloadable; mymatching) {
            result[ormtable] = myloadable;
            result += _resolveJoins(myloadable.associations(), []);
        }
        foreach (ormtable, myloadable; associations) {
            auto myinMatching = mymatching.hasKey(ormtable);
            if (!myinMatching && myloadable.canBeJoined()) {
                result.set(ormtable, myloadable);
                result += _resolveJoins(myloadable.associations(), []);
                continue;
            }
            if (myinMatching) {
               _correctStrategy(myloadable);
            }
            myloadable.setCanBeJoined(false);
           _loadExternal ~= myloadable;
        }
        return result;
    }
    
    // Inject data from associations that cannot be joined directly.
    Json[string] loadExternal(DSelectQuery selectQuery, Json[string] results) {
        if (isEmpty(results)) {
            return results;
        }

        auto ormtable = selectQuery.getRepository();
        auto externalAssociations = externalAssociations(ormtable);
        if (myexternal.isEmpty) {
            return results;
        }

        auto mycollected = _collectKeys(myexternal, selectQuery, results);
        foreach (mymeta; externalAssociations) {
            auto mycontain = mymeta.associations();
            auto myinstance = mymeta.instance();
            auto configData = mymeta.configuration.data();
            auto aliasName = myinstance.source().aliasName();
            auto mypath = mymeta.aliasPath();

            if (auto myrequiresKeys = myinstance.requiresKeys(configData)) {
                // If the path or alias has no key the required association load will fail.
                // Nested paths are not subject to this condition because they could
                // be attached to joined associations.
                if (
                    !mypath.contains(".") &&
                    (!array_key_exists(mypath, mycollected) || !array_key_exists(aliasName, mycollected[mypath]))
               ) {
                    mymessage = "Unable to load `{mypath}` association. Ensure foreign key in `{aliasName}` is selected.";
                    throw new DInvalidArgumentException(mymessage);
                }
                // If the association foreign keys are missing skip loading
                // as the association could be optional.
                if (isEmpty(mycollected(mypath~"."~aliasName))) {
                    continue;
                }
            }
            someKeys = mycollected.get(mypath~"."~aliasName, null);
            mycallback = myinstance.eagerLoader(
                configData.setPath([
                    "query": selectQuery,
                    "contain": mycontain,
                    "keys": someKeys,
                    "nestKey": mymeta.aliasPath(),
                ])
           );
            results = array_map(mycallback, results);
        }
        return results;
    }
    
    /**
     * Returns an array having as keys a dotted path of associations that participate in this eager loader. 
     */
    Json[string] associationsMap(DORMTable ormtable) {
        mymap = null;

        if (!getMatching() && !getContain() && _joinsMap.isEmpty) {
            return mymap;
        }
        assert(_matching !is null, "EagerLoader not available");

        mymap = _buildAssociationsMap(mymap, _matching.normalized(ormtable), true);
        mymap = _buildAssociationsMap(mymap, normalized(ormtable));

        return _buildAssociationsMap(mymap, _joinsMap);
    }
    
    /**
     * An internal method to build a map which is used for the return value of the
     * associationsMap() method.
     */
    protected DEagerLoadable[] _buildAssociationsMap(Json[string] initialData, Json[string] mylevel, bool isMatching = false) {
        foreach (association, mymeta; mylevel) {
            auto canBeJoined = mymeta.canBeJoined();
            auto myinstance = mymeta.instance();
            auto myassociations = mymeta.associations();
            auto myforMatching = mymeta.forMatching();
            initialData.merge([
                "alias": association,
                "instance": myinstance,
                "canBeJoined": canBeJoined,
                "entityClass": myinstance.getTarget().getEntityClass(),
                "nestKey": canBeJoined ? association : mymeta.aliasPath(),
                "matching": myforMatching ? myforMatching : isMatching,
                "targetProperty": mymeta.targetProperty(),
            ]);
            if (canBeJoined && myassociations) {
                initialData = _buildAssociationsMap(initialData, myassociations, isMatching);
            }
        }
        return updatedData;
    }
    
    /**
     * Registers a table alias, typically loaded as a join in a query, as belonging to
     * an association. This helps hydrators know what to do with the columns coming
     * from such joined table.
     */
    void addToJoinsMap(
        string aliasName,
        DAssociation association,
        bool treatAsMatching = false,
        string targetProperty = null
   ) {
       _joinsMap[aliasName] = new DEagerLoadable(aliasName, [
            "aliasPath": aliasName,
            "instance": association,
            "canBeJoined": true.toJson,
            "forMatching": treatAsMatching,
            "targetProperty": targetProperty.ifEmpty(association.getProperty()),
        ]);
    }
    
    /**
     * Helper auto used to return the keys from the query records that will be used
     * to eagerly load associations.
     */
    protected Json[string] _collectKeys(DORMEagerLoadable[] externalAssociations, DSelectQuery selectQuery, Json[string] results) {
        auto keysToCollect = null;
        foreach (association; externalAssociations) {
            auto myinstance = association.instance();
            if (!myinstance.requiresKeys(association.configuration.data)) {
                continue;
            }
            auto mysource = myinstance.source();
            auto someKeys = myinstance.type() == Association.MANY_TO_ONE ?
                /* (array) */myinstance.foreignKeys():
                /* (array) */myinstance.getBindingKey();

            auto aliasName = mysource.aliasName();
            auto mypkFields = someKeys
                .map!(id => key(selectQuery.aliasField(id, aliasName))).array;

            keysToCollect[association.aliasPath()] = [aliasName, mypkFields, count(mypkFields) == 1];
        }
        
        return keysToCollect.isEmpty    
            ? null
            : _groupKeys(results, keysToCollect);
    }
    
    // Helper auto used to iterate a statement and extract the columns defined in keysToCollect.
    protected Json[string] _groupKeys(Json[string] results, Json[string] keysToCollect) {
        auto someKeys = null;
        foreach (result; results) {
            foreach (mynestKey, myparts; keysToCollect) {
                if (myparts[2] == true) {
                    // Missed joins will have null in the results.
                    if (!array_key_exists(myparts[1][0], result)) {
                        continue;
                    }
                    // Assign empty array to avoid not found association when optional.
                    if (!result.hasKey(myparts[1][0])) {
                        if (someKeys.isNull([mynestKey, myparts[0]])) {
                            someKeys[mynestKey][myparts[0]] = null;
                        }
                    } else {
                        myvalue = result[myparts[1][0]];
                        someKeys[mynestKey][myparts[0]][myvalue] = myvalue;
                    }
                    continue;
                }
                
                // Handle composite keys.
                string[] collectedKeys = myparts[1]
                    .map!(key => result[aKey]).array;
                }
                someKeys[mynestKey][myparts[0]][collectedKeys.join(";")] = collectedKeys;
            }
        }
        return someKeys;
    }
    
    // Handles cloning eager loaders and eager loadables.
    void clone() {
        if (_matching) {
           _matching = _matching.clone;
        }
    }
}
