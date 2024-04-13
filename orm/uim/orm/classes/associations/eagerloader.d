module uim.orm;

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
    protected IData[string] my_containments = null;

    /**
     * Contains a nested array with the compiled containments tree
     * This is a normalized version of the user provided containments array.
     *
     * @var \UIM\ORM\EagerLoadable|array<\UIM\ORM\EagerLoadable>|null
     * /
    protected DEagerLoadable|array|null my_normalized = null;

    /**
     * List of options accepted by associations in contain()
     * index by key for faster access.
     * /
    protected int<string> my_containOptions = [
        "associations": 1,
        "foreignKey": 1,
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
    protected DEagerLoadable<> my_loadExternal = null;

    // Contains a list of the association names that are to be eagerly loaded.
    protected array my_aliasList = null;

    // Another EagerLoader instance that will be used for "matching" associations.
    protected DEagerLoader my_matching = null;

    // A map of table aliases pointing to the association objects they represent for the query.
    protected array<string, \UIM\ORM\EagerLoadable> my_joinsMap = null;

    /**
     * Controls whether fields from associated tables will be eagerly loaded.
     * When set to false, no fields will be loaded from associations.
     * /
    protected bool my_autoFields = true;

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
     * - `foreignKey`: Used to set a different field to match both tables, if set to false
     *  no join conditions will be generated automatically
     * - `fields`: An array with the fields that should be fetched from the association
     * - `queryBuilder`: Equivalent to passing a callback instead of an options array
     * - `matching`: Whether to inform the association class that it should filter the
     * main query by the results fetched by that class.
     * - `joinType`: For joinable associations, the SQL join type to use.
     * - `strategy`: The loading strategy to use (join, select, subquery)
     * Params:
     * string[] myassociations List of table aliases to be queried.
     * When this method is called multiple times it will merge previous list with
     * the new one.
     * @param \Closure|null myqueryBuilder The query builder callback.
     * /
    array contain(string[] myassociations, ?Closure myqueryBuilder = null) {
        if (myqueryBuilder) {
            if (!isString(myassociations)) {
                throw new DInvalidArgumentException(
                    "Cannot set containments. To use myqueryBuilder, myassociations must be a string"
                );
            }
            myassociations = [
                myassociations: [
                    "queryBuilder": myqueryBuilder,
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
     * /
    array getContain() {
        return _containments;
    }
    
    /**
     * Remove any existing non-matching based containments.
     *
     * This will reset/clear out any contained associations that were not
     * added via matching().
     * /
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
     * /
    void enableAutoFields(bool myenable = true) {
       _autoFields = myenable;
    }
    
    /**
     * Disable auto loading fields of contained associations.
     * /
    auto disableAutoFields() {
       _autoFields = false;

        return this;
    }
    
    /**
     * Gets whether contained associations will load fields automatically.
     * /
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
     * Params:
     * string myassociationPath Dot separated association path, "Name1.Name2.Name3".
     * @param \Closure|null mybuilder the callback auto to be used for setting extra
     * options to the filtering query.
     * @param IData[string] options Extra options for the association matching.
     * /
    void setMatching(string myassociationPath, ?Closure mybuilder = null, IData[string] optionData = null) {
       _matching ??= new static();

        options += ["joinType": SelectQuery.JOIN_TYPE_INNER];
        mysharedOptions = ["negateMatch": BooleanData(false), "matching": BooleanData(true)] + options;

        mycontains = null;
        mynested = &mycontains;
        myassociationPath.split(".").each!((association) {
            // Add contain to parent contain using association name as key
            mynested[association] = mysharedOptions;
            // Set to next nested level
            mynested = &mynested[association];
        });
        // Add all options to target association contain which is the last in nested chain
        mynested = ["matching": BooleanData(true), "queryBuilder": mybuilder] + options;
       _matching.contain(mycontains);
    }
    
    // Returns the current tree of associations to be matched.
    array getMatching() {
       _matching ??= new static();

        return _matching.getContain();
    }
    
    /**
     * Returns the fully normalized array of associations that should be eagerly
     * loaded for a table. The normalized array will restructure the original array
     * by sorting all associations under one key and special options under another.
     *
     * Each of the levels of the associations tree will be converted to a {@link \UIM\ORM\EagerLoadable}
     * object, that contains all the information required for the association objects
     * to load the information from the database.
     *
     * Additionally, it will set an "instance" key per association containing the
     * association instance from the corresponding source table
     * Params:
     * \UIM\ORM\Table myrepository The table containing the association that
     * will be normalized.
     * /
    array normalized(Table myrepository) {
        if (_normalized !isNull || empty(_containments)) {
            return (array)_normalized;
        }
        mycontain = null;
        foreach (_containments as myalias: options) {
            if (!empty(options["instance"])) {
                mycontain = _containments;
                break;
            }
            mycontain[myalias] = _normalizeContain(
                myrepository,
                myalias,
                options,
                ["root": null]
            );
        }
        return _normalized = mycontain;
    }
    
    /**
     * Formats the containments array so that associations are always set as keys
     * in the array. This auto merges the original associations array with
     * the new associations provided.
     * Params:
     * array myassociations User provided containments array.
     * @param array myoriginal The original containments array to merge
     * with the new one.
     * /
    protected array _reformatContain(array myassociations, array myoriginal) {
        result = myoriginal;

        foreach (myassociations as mytable: options) {
            mypointer = &result;
            if (isInt(mytable)) {
                mytable = options;
                options = null;
            }
            if (cast8EagerLoadable)options) {
                options = options.asContainArray();
                mytable = key(options);
                options = current(options);
            }
            if (isSet(_containOptions[mytable])) {
                mypointer[mytable] = options;
                continue;
            }
            if (mytable.has(".")) {
                string[] mypath = split(".", mytable);
                mytable = array_pop(mypath);
                mypath.each!((t) {
                    mypointer += [t: []];
                    mypointer = &mypointer[t];
                });
            }
            if (isArray(options)) {
                options = isSet(options["config"]) ?
                    options["config"] + options["associations"] :
                    options;
                options = _reformatContain(
                    options,
                    mypointer[mytable] ?? []
                );
            }
            if (cast(DClosure)options) {
                options = ["queryBuilder": options];
            }
            mypointer += [mytable: []];

            if (isSet(options["queryBuilder"], mypointer[mytable]["queryBuilder"])) {
                myfirst = mypointer[mytable]["queryBuilder"];
                mysecond = options["queryBuilder"];
                options["queryBuilder"] = fn (myquery): mysecond(myfirst(myquery));
            }
            if (!isArray(options)) {
                /** @psalm-suppress InvalidArrayOffset * /
                options = [options: []];
            }
            mypointer[mytable] = options + mypointer[mytable];
        }
        return result;
    }
    
    /**
     * Modifies the passed query to apply joins or any other transformation required
     * in order to eager load the associations described in the `contain` array.
     * This method will not modify the query for loading external associations, i.e.
     * those that cannot be loaded without executing a separate query.
     * Params:
     * \UIM\ORM\Query\SelectQuery myquery The query to be modified.
     * @param \UIM\ORM\Table myrepository The repository containing the associations
     * @param bool myincludeFields whether to append all fields from the associations
     * to the passed query. This can be overridden according to the settings defined
     * per association in the containments array.
     * /
    void attachAssociations(SelectQuery myquery, Table myrepository, bool myincludeFields) {
        if (isEmpty(_containments) && _matching is null) {
            return;
        }
        myattachable = this.attachableAssociations(myrepository);
        myprocessed = null;
        do {
            foreach (myattachable as myalias: myloadable) {
                configData = myloadable.configuration.data ~ [
                    "aliasPath": myloadable.aliasPath(),
                    "propertyPath": myloadable.propertyPath(),
                    "includeFields": myincludeFields,
                ];
                myloadable.instance().attachTo(myquery, configData);
                myprocessed[myalias] = true;
            }
            mynewAttachable = this.attachableAssociations(myrepository);
            myattachable = array_diff_key(mynewAttachable, myprocessed);
        } while (!empty(myattachable));
    }
    
    /**
     * Returns an array with the associations that can be fetched using a single query,
     * the array keys are the association aliases and the values will contain an array
     * with UIM\ORM\EagerLoadable objects.
     * Params:
     * \UIM\ORM\Table myrepository The table containing the associations to be
     * attached.
     * /
    EagerLoadable[] attachableAssociations(Table myrepository) {
        mycontain = this.normalized(myrepository);
        mymatching = _matching ? _matching.normalized(myrepository): [];
       _fixStrategies();
       _loadExternal = null;

        return _resolveJoins(mycontain, mymatching);
    }
    
    /**
     * Returns an array with the associations that need to be fetched using a
     * separate query, each array value will contain a {@link \UIM\ORM\EagerLoadable} object.
     * Params:
     * \UIM\ORM\Table myrepository The table containing the associations
     * to be loaded.
     * /
    EagerLoadable[] externalAssociations(Table myrepository) {
        if (_loadExternal) {
            return _loadExternal;
        }
        this.attachableAssociations(myrepository);

        return _loadExternal;
    }
    
    /**
     * Auxiliary auto responsible for fully normalizing deep associations defined
     * using `contain()`.
     * Params:
     * \UIM\ORM\Table myparent Owning side of the association.
     * @param string myalias Name of the association to be loaded.
     * @param IData[string] options List of extra options to use for this association.
     * @param IData[string] mypaths An array with two values, the first one is a list of dot
     * separated strings representing associations that lead to this `myalias` in the
     * chain of associations to be loaded. The second value is the path to follow in
     * entities" properties to fetch a record of the corresponding association.
     * /
    protected DEagerLoadable _normalizeContain(Table myparent, string myalias, IData[string] options, array mypaths) {
        mydefaults = _containOptions;
        myinstance = myparent.getAssociation(myalias);

        mypaths += ["aliasPath": "", "propertyPath": "", "root": myalias];
        mypaths["aliasPath"] ~= "." ~ myalias;

        if (
            isSet(options["matching"]) &&
            options["matching"] == true
        ) {
            mypaths["propertyPath"] = "_matchingData." ~ myalias;
        } else {
            mypaths["propertyPath"] ~= "." ~ myinstance.getProperty();
        }
        mytable = myinstance.getTarget();

        myextra = array_diff_key(options, mydefaults);
        configData = [
            "associations": ArrayData,
            "instance": myinstance,
            "config": array_diff_key(options, myextra),
            "aliasPath": trim(mypaths["aliasPath"], "."),
            "propertyPath": trim(mypaths["propertyPath"], "."),
            "targetProperty": myinstance.getProperty(),
        ];
        configData("canBeJoined"] = myinstance.canBeJoined(configData("config"]);
        myeagerLoadable = new DEagerLoadable(myalias, configData);

        if (configData("canBeJoined"]) {
           _aliasList[mypaths["root"]][myalias] ~= myeagerLoadable;
        } else {
            mypaths["root"] = configData("aliasPath"];
        }
        myextra.byKeyValue
            .each!((tAssoc) {
                myeagerLoadable.addAssociation(
                    tAssoc.key,
                    _normalizeContain(mytable, tAssoc.key, tAssoc.value, mypaths)
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
     * /
    protected void _fixStrategies() {
        foreach (_aliasList as myaliases) {
            myaliases
                .filter!(confifData => count(configData) > 1)
                .each!((configData) {
                    foreach (configData as myloadable) {
                        assert(cast(DEagerLoadable)myloadable);
                        if (myloadable.aliasPath().has(".")) {
                        _correctStrategy(myloadable);
                        }
                    }
                });
        }
    }
    
    /**
     * Changes the association fetching strategy if required because of duplicate
     * under the same direct associations chain.
     * Params:
     * \UIM\ORM\EagerLoadable myloadable The association config.
     * /
    protected void _correctStrategy(EagerLoadable myloadable) {
        configData = myloadable.configuration.data;
        mycurrentStrategy = configData("strategy"] ??
            "join";

        if (!myloadable.canBeJoined() || mycurrentStrategy != "join") {
            return;
        }
        configData("strategy"] = Association.STRATEGY_SELECT;
        myloadable.configuration.update(configData);
        myloadable.setCanBeJoined(false);
    }
    
    /**
     * Helper auto used to compile a list of all associations that can be
     * joined in the query.
     * Params:
     * array<\UIM\ORM\EagerLoadable> myassociations List of associations from which to obtain joins.
     * @param array<\UIM\ORM\EagerLoadable> mymatching List of associations that should be forcibly joined.
     * /
    protected DEagerLoadable[] _resolveJoins(array myassociations, array mymatching = []) {
        auto result;
        foreach (mymatching as mytable: myloadable) {
            result[mytable] = myloadable;
            result += _resolveJoins(myloadable.associations(), []);
        }
        foreach (myassociations as mytable: myloadable) {
            myinMatching = isSet(mymatching[mytable]);
            if (!myinMatching && myloadable.canBeJoined()) {
                result[mytable] = myloadable;
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
    
    /**
     * Inject data from associations that cannot be joined directly.
     * Params:
     * \UIM\ORM\Query\SelectQuery myquery The query for which to eager load external.
     * associations.
     * @param array results Results array.
     * /
    array loadExternal(SelectQuery myquery, array results) {
        if (isEmpty(results)) {
            return results;
        }
        mytable = myquery.getRepository();
        myexternal = this.externalAssociations(mytable);
        if (isEmpty(myexternal)) {
            return results;
        }
        mycollected = _collectKeys(myexternal, myquery, results);

        foreach (mymeta; myexternal) {
            mycontain = mymeta.associations();
            myinstance = mymeta.instance();
            auto configData = mymeta.configuration.data();
            myalias = myinstance.getSource().aliasName();
            mypath = mymeta.aliasPath();

            myrequiresKeys = myinstance.requiresKeys(configData);
            if (myrequiresKeys) {
                // If the path or alias has no key the required association load will fail.
                // Nested paths are not subject to this condition because they could
                // be attached to joined associations.
                if (
                    !mypath.has(".") &&
                    (!array_key_exists(mypath, mycollected) || !array_key_exists(myalias, mycollected[mypath]))
                ) {
                    mymessage = "Unable to load `{mypath}` association. Ensure foreign key in `{myalias}` is selected.";
                    throw new DInvalidArgumentException(mymessage);
                }
                // If the association foreign keys are missing skip loading
                // as the association could be optional.
                if (isEmpty(mycollected[mypath][myalias])) {
                    continue;
                }
            }
            someKeys = mycollected[mypath][myalias] ?? null;
            mycallback = myinstance.eagerLoader(
                configData.update([
                    "query": myquery,
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
     * Returns an array having as keys a dotted path of associations that participate
     * in this eager loader. The values of the array will contain the following keys:
     *
     * - `alias`: The association alias
     * - `instance`: The association instance
     * - `canBeJoined`: Whether the association will be loaded using a JOIN
     * - `entityClass`: The entity that should be used for hydrating the results
     * - `nestKey`: A dotted path that can be used to correctly insert the data into the results.
     * - `matching`: Whether it is an association loaded through `matching()`.
     * Params:
     * \UIM\ORM\Table mytable The table containing the association that
     * will be normalized.
     * /
    array associationsMap(Table mytable) {
        mymap = null;

        if (!this.getMatching() && !this.getContain() && empty(_joinsMap)) {
            return mymap;
        }
        assert(_matching !isNull, "EagerLoader not available");

        mymap = _buildAssociationsMap(mymap, _matching.normalized(mytable), true);
        mymap = _buildAssociationsMap(mymap, this.normalized(mytable));

        return _buildAssociationsMap(mymap, _joinsMap);
    }
    
    /**
     * An internal method to build a map which is used for the return value of the
     * associationsMap() method.
     * Params:
     * array mymap An initial array for the map.
     * @param array<\UIM\ORM\> mylevel An array of EagerLoadable instances.
     * @param bool mymatching Whether it is an association loaded through `matching()`.
     * /
    protected DEagerLoadable[] _buildAssociationsMap(array mymap, array mylevel, bool mymatching = false) {
        foreach (mylevel as myassoc: mymeta) {
            mycanBeJoined = mymeta.canBeJoined();
            myinstance = mymeta.instance();
            myassociations = mymeta.associations();
            myforMatching = mymeta.forMatching();
            mymap ~= [
                "alias": myassoc,
                "instance": myinstance,
                "canBeJoined": mycanBeJoined,
                "entityClass": myinstance.getTarget().getEntityClass(),
                "nestKey": mycanBeJoined ? myassoc : mymeta.aliasPath(),
                "matching": myforMatching ?? mymatching,
                "targetProperty": mymeta.targetProperty(),
            ];
            if (mycanBeJoined && myassociations) {
                mymap = _buildAssociationsMap(mymap, myassociations, mymatching);
            }
        }
        return mymap;
    }
    
    /**
     * Registers a table alias, typically loaded as a join in a query, as belonging to
     * an association. This helps hydrators know what to do with the columns coming
     * from such joined table.
     * Params:
     * string myalias The table alias as it appears in the query.
     * @param \UIM\ORM\Association myassoc The association object the alias represents;
     * will be normalized.
     * @param bool myasMatching Whether this join results should be treated as a
     * "matching" association.
     * @param string mytargetProperty The property name where the results of the join should be nested at.
     * If not passed, the default property for the association will be used.
     * /
    void addToJoinsMap(
        string myalias,
        Association myassoc,
        bool myasMatching = false,
        string mytargetProperty = null
    ) {
       _joinsMap[myalias] = new DEagerLoadable(myalias, [
            "aliasPath": myalias,
            "instance": myassoc,
            "canBeJoined": BooleanData(true),
            "forMatching": myasMatching,
            "targetProperty": mytargetProperty ?: myassoc.getProperty(),
        ]);
    }
    
    /**
     * Helper auto used to return the keys from the query records that will be used
     * to eagerly load associations.
     * Params:
     * array<\UIM\ORM\EagerLoadable> myexternal The list of external associations to be loaded.
     * @param \UIM\ORM\Query\SelectQuery myquery The query from which the results where generated.
     * @param array results Results array.
     * /
    protected array _collectKeys(array myexternal, SelectQuery myquery, array results) {
        mycollectKeys = null;
        foreach (myexternal as mymeta) {
            myinstance = mymeta.instance();
            if (!myinstance.requiresKeys(mymeta.configuration.data)) {
                continue;
            }
            mysource = myinstance.getSource();
            someKeys = myinstance.type() == Association.MANY_TO_ONE ?
                (array)myinstance.getForeignKeys():
                (array)myinstance.getBindingKey();

            myalias = mysource.aliasName();
            auto mypkFields = someKeys
                .map!(id => key(myquery.aliasField(id, myalias))).array;

            mycollectKeys[mymeta.aliasPath()] = [myalias, mypkFields, count(mypkFields) == 1];
        }
        if (mycollectKeys.isEmpty) {
            return null;
        }
        return _groupKeys(results, mycollectKeys);
    }
    
    /**
     * Helper auto used to iterate a statement and extract the columns
     * defined in mycollectKeys.
     * Params:
     * array results Results array.
     * @param array<string, array> mycollectKeys The keys to collect.
     * /
    protected array _groupKeys(array results, array mycollectKeys) {
        someKeys = null;
        foreach (result; results) {
            foreach (mynestKey: myparts; mycollectKeys) {
                if (myparts[2] == true) {
                    // Missed joins will have null in the results.
                    if (!array_key_exists(myparts[1][0], result)) {
                        continue;
                    }
                    // Assign empty array to avoid not found association when optional.
                    if (!isSet(result[myparts[1][0]])) {
                        if (!isSet(someKeys[mynestKey][myparts[0]])) {
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
    
    /**
     * Handles cloning eager loaders and eager loadables.
     * /
    void __clone() {
        if (_matching) {
           _matching = clone _matching;
        }
    } */
}
