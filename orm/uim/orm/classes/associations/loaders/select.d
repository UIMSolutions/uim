module uim.orm.classes.associations.loaders.select;

import uim.orm;

@safe:

/**
 * : the logic for loading an association using a SELECT query
 *
 * @internal
 */
class DSelectLoader {
    bool initialize(Json[string] initData = null) {
        _aliasName = options.getString("alias");
        _sourceAlias = options.getString("sourceAlias");
        _targetAlias = options.getString("targetAlias");
        _foreignKey = options.getStringArray("foreignKeys");
        _strategy = options.getString("strategy");
        _bindingKey = options.getString("bindingKey");
        _finder = options.get("finder");
        _associationType = options.get("associationType");
        _sort = options.get("sort");

        return true;
    }
    
    // The alias of the association loading the results
    protected string _aliasName;

    // The alias of the source association
    protected string _sourceAlias;

    // The alias of the target association
    protected string _targetAlias;

    // The foreignKeys to the target association
    protected string[] _foreignKeys;

    // The strategy to use for loading, either select or subquery
    protected string _strategy;

    // The binding key for the source association.
    protected string _bindingKey;

    /**
     * A callable that will return a query object used for loading the association results
     *
     * @var callable
     */
    protected finder;

    // The type of the association triggering the load
    protected string associationType;

    // The sorting options for loading the association
    protected string sort;

    /**
     * Returns a callable that can be used for injecting association results into a given
     * iterator. The options accepted by this method are the same as `Association.eagerLoader()`
     */
    Closure buildEagerLoader(Json[string] options = null) {
        auto updatedOptions = options.update_defaultOptions();
        fetchQuery = _buildQuery(options);
        resultMap = _buildResultMap(fetchQuery, options);

        return _resultInjector(fetchQuery, resultMap, options);
    } 

    // Returns the default options to use for the eagerLoader
    protected Json[string] _defaultOptions() {
        return [
            "foreignKeys": Json(_foreignKey),
            "conditions": Json.emptyArray,
            "strategy": Json(_strategy),
            "nestKey": Json(_alias),
            "sort": Json(_sort),
        ];
    }

    /**
     * Auxiliary function to construct a new Query object to return all the records
     * in the target table that are associated to those specified in options from
     * the source table
     */
    protected DORMQuery _buildQuery(Json[string] options = null) {
        auto key = _linkField(options);
        auto filter = options["keys"];
        auto useSubquery = options["strategy"] == Association.STRATEGY_SUBQUERY;
        auto finder = this.finder;
        options["fields"] = options.get("fields", null);

        /** @var DORMQuery query */
        DORMQuery query = finder();
        if (options.hasKey("finder")) {
            [finderName, opts] = _extractFinder(options["finder"]);
            query = query.find(finderName, opts);
        }

        auto fetchQuery = query
            .select(options["fields"])
            .where(options["conditions"])
            .eagerLoaded(true)
            .enableHydration(options["query"].isHydrationEnabled());
        if (options["query"].isResultsCastingEnabled()) {
            fetchQuery.enableResultsCasting();
        } else {
            fetchQuery.disableResultsCasting();
        }

        if (useSubquery) {
            filter = _buildSubquery(options["query"]);
            fetchQuery = _addFilteringJoin(fetchQuery, key, filter);
        } else {
            fetchQuery = _addFilteringCondition(fetchQuery, key, filter);
        }

        if (!options.isEmpty("sort")) {
            fetchQuery.order(options["sort"]);
        }

        if (!options.isEmpty("contain")) {
            fetchQuery.contain(options["contain"]);
        }

        if (!options.isEmpty("queryBuilder")) {
            fetchQuery = options["queryBuilder"](fetchQuery);
        }

        _assertFieldsPresent(fetchQuery, (array)key);

        return fetchQuery;
    }

    /**
     * Helper method to infer the requested finder and its options.
     *
     * Returns the inferred options from the finder type.
     *
     * ### Examples:
     *
     * The following will call the finder "translations" with the value of the finder as its options:
     * query.contain(["Comments": ["finder": ["translations"]]]);
     * query.contain(["Comments": ["finder": ["translations": Json.emptyArray]]]);
     * query.contain(["Comments": ["finder": ["translations": ["locales": ["en_US"]]]]]);
     *
     * @param array|string finderData The finder name or an array having the name as key
     * and options as value.
     */
    protected Json[string] _extractFinder(finderData) {
        finderData = /* (array) */finderData;

        if (key(finderData).isNumeric) {
            return [currentValue(finderData), []];
        }

        return [key(finderData), currentValue(finderData)];
    }

    /**
     * Checks that the fetching query either has auto fields on or
     * has the foreignKeys fields selected.
     * If the required fields are missing, throws an exception.
     *
     * @param DORMQuery fetchQuery The association fetching query
     * @param string[] key The foreign key fields to check
     */
    protected void _assertFieldsPresent(Query fetchQuery, Json[string] key) {
        if (fetchQuery.isAutoFieldsEnabled()) {
            return;
        }

        select = fetchQuery.aliasFields(fetchQuery.clause("select"));
        if (select.isEmpty) {
            return;
        }
        missingKey = function (fieldList, key) {
            return key.any!(field => !isIn(field, fieldList, true));
        };

        missingFields = missingKey(select, key);
        if (missingFields) {
            driver = fetchQuery.getConnection().getDriver();
            quoted = array_map([driver, "quoteIdentifier"], key);
            missingFields = missingKey(select, quoted);
        }

        if (missingFields) {
            throw new DInvalidArgumentException(
                    "You are required to select the '%s' field(s)"
                    .format(", ", key)
           );
        }
    }

    /**
     * Appends any conditions required to load the relevant set of records in the
     * target table query given a filter key and some filtering values when the
     * filtering needs to be done using a subquery.
     *
     * @param DORMQuery query Target table"s query
     * @param string[]|string aKey the fields that should be used for filtering
     * @param DORMQuery subquery The Subquery to use for filtering
     */
    protected DORMQuery _addFilteringJoin(Query query, key, DORMQuery filteringQuery) { 
        auto filter = null;
        auto aliasedTable = this.sourceAlias;

        foreach (aliasedField, field; filteringQuery.clause("select")) {
            if (is_int(aliasedField)) {
                filter ~= new DIdentifierExpression(field);
            } else {
                filter[aliasedField] = field;
            }
        }
        filteringQuery.select(filter, true);

        if (key.isArray) {
            conditions = _createTupleCondition(query, key, filter, "=");
        } else {
            filter = currentValue(filter);
            conditions = query.newExpr([key: filter]);
        }

        return query.innerJoin(
            [aliasedTable: filteringQuery],
            conditions
       );
    }

    /**
     * Appends any conditions required to load the relevant set of records in the
     * target table query given a filter key and some filtering values.
     *
     * @param DORMQuery query Target table"s query
     * @param string[]|string aKey The fields that should be used for filtering
     * @param mixed filter The value that should be used to match for key
     */
    protected DORMQuery _addFilteringCondition(Query query, key, filter) {
        if ((key.isArray) {
            conditions = _createTupleCondition(query, key, filter, "IN");
        } else {
            conditions = [key ~ " IN": filter];
        }

        return query.andWhere(conditions);
    }

    /**
     * Returns a TupleComparison object that can be used for matching all the fields
     * from keys with the tuple values in filter using the provided operator.
     *
     * @param DORMQuery query Target table"s query
     * @param string[] keys the fields that should be used for filtering
     * @param mixed filter the value that should be used to match for key
     * @param string operator The operator for comparing the tuples
     */
    protected TupleComparison _createTupleCondition(DQuery query, Json[string] keys, Json filter, string operator) {
        auto types = null;
        auto defaults = query.getDefaultTypes();
        foreach (key; keys) {
            if (defaults.hascorrectKey(key)) {
                types ~= defaults[key];
            }
        }

        return new DTupleComparison(keys, filter, types, operator);
    }

    /**
     * Generates a string used as a table field that contains the values upon
     * which the filter should be applied
     */
    protected string[] _linkField(Json[string] options = null) {
        auto links = null;
        auto name = _aliasName;

        if (options.get("foreignKeys") == false && this.associationType == Association.ONE_TO_MANY) {
            auto message = "Cannot have foreignKeys = false for hasMany associations~ " ~
                   "You must provide a foreignKeys column.";
            throw new DRuntimeException(message);
        }

        auto keys = isIn(this.associationType, [Association.ONE_TO_ONE, Association.ONE_TO_MANY], true) ?
            _foreignKeys :
            _bindingKeys;

        foreach (key; keys) {
            links ~=  "%s.%s".format(name, key);
        }

        if (count(links) == 1) {
            return links[0];
        }

        return links;
    }

    /**
     * Builds a query to be used as a condition for filtering records in the
     * target table, it is constructed by cloning the original query that was used
     * to load records in the source table.
     */
    protected DORMQuery _buildSubquery(DORMQuery query) {
        auto filterQuery = query.clone;
        filterQuery.disableAutoFields();
        filterQuery.mapReduce(null, null, true);
        filterQuery.formatResults(null, true);
        filterQuery.contain([], true);
        filterQuery.setValueBinder(new DValueBinder());

        // Ignore limit if there is no order since we need all rows to find matches
        if (!filterQuery.clause("limit") || !filterQuery.clause("order")) {
            filterQuery.limit(null);
            filterQuery.order([], true);
            filterQuery.offset(null);
        }

        auto fields = _subqueryFields(query);
        filterQuery.select(fields["select"], true).group(fields["group"]);

        return filterQuery;
    }

    /**
     * Calculate the fields that need to participate in a subquery.
     *
     * Normally this includes the binding key columns. If there is a an ORDER BY,
     * those columns are also included as the fields may be calculated or constant values,
     * that need to be present to ensure the correct association data is loaded.
     *
     * @param DORMQuery query The query to get fields from.
     */
    protected Json[string] _subqueryFields(Query query) {
        string[] keys = _bindingKeys;

        if (this.associationType == Association.MANY_TO_ONE) {
            keys = (array)_foreignKeys;
        }

        auto fields = query.aliasFields(keys, this.sourceAlias);
        auto group = fields = array_values(fields);
        auto order = query.clause("order");
        if (order) {
            auto columns = query.clause("select");
            /* order.iterateParts(void (direction, field) use (&fields, columns) {
                if (columns.hasKey(field)) {
                    fields[field] = columns[field];
                }
            }); */
        }

        return ["select": fields, "group": group];
    }

    /**
     * Builds an array containing the results from fetchQuery indexed by
     * the foreignKeys value corresponding to this association.
     *
     * @param DORMQuery fetchQuery The query to get results from
     * @param Json[string] options The options passed to the eager loader
     */
    protected Json[string] _buildResultMap(Query fetchQuery, Json[string] options = null) {
        auto resultMap = null;
        auto singleResult = isIn(this.associationType, [Association.MANY_TO_ONE, Association.ONE_TO_ONE], true);
        auto keys = isIn(this.associationType, [Association.ONE_TO_ONE, Association.ONE_TO_MANY], true) 
            ? _foreignKeys 
            : _bindingKeys;
        string[] someKeys = (array)keys;

        foreach (result; fetchQuery.all()) {
            string[] values = null;
            foreach (key; someKeys) {
                values ~= result[key];
            }
            if (singleResult) {
                resultMap[values.join(";")] = result;
            } else {
                resultMap[values.join(";")] ~= result;
            }
        }

        return resultMap;
    }

    /**
     * Returns a callable to be used for each row in a query result set
     * for injecting the eager loaded rows
     *
     * @param DORMQuery fetchQuery the Query used to fetch results
     * @param Json[string] resultMap an array with the foreignKeys as keys and
     * the corresponding target table results as value.
     */
     // TODO
    /* protected Closure _resultInjector(Query fetchQuery, Json[string] resultMap, Json[string] options = null) {
        keys = this.associationType == Association.MANY_TO_ONE ?
            _foreignKeys :
            _bindingKeys;

        auto someSourceKeys = null;
        foreach (key; keys) {
            f = fetchQuery.aliasField(key, this.sourceAlias);
            someSourceKeys ~= key(f);
        }

        auto nestKey = options["nestKey"];
        if (count(someSourceKeys) > 1) {
            return _multiKeysInjector(resultMap, someSourceKeys, nestKey);
        }

        auto sourceKey = someSourceKeys[0];
        return function (row) use (resultMap, sourceKey, nestKey) {
            if (row.hasKey(sourceKey) && resultMap.hasKey(row[sourceKey])) {
                row[nestKey] = resultMap[row[sourceKey]];
            }

            return row;
        };
    } */

    /**
     * Returns a callable to be used for each row in a query result set
     * for injecting the eager loaded rows when the matching needs to
     * be done with multiple foreign keys
     *
     * @param Json[string] resultMap A keyed arrays containing the target table
     * someSourceKeys - An array with aliased keys to match
     * @param string nestKey The key under which results should be nested
     */
    protected DClosure _multiKeysInjector(Json[string] resultMap, string[] someSourceKeys, string nestKey) {
        // TODO 
        /* return function (row) use (resultMap, someSourceKeys, nestKey) {
            string[] values = someSourceKeys.map!(key => row[key]).array;

            string key = values.join(";");
            if (resultMap.hascorrectKey(key)) {
                row[nestKey] = resultMap.get(key);
            }

            return row;
        }; */
        return null; 
    }
}
