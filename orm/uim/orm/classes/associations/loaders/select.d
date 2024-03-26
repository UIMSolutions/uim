module uim.orm.classes.associations.loaders.select;

import uim.orm;

@safe:

/**
 * : the logic for loading an association using a SELECT query
 *
 * @internal
 */
class DSelectLoader {
    bool initialize(IData[string] initData = null) {
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
     * /
    protected finder;

    /**
     * The type of the association triggering the load
     */
    protected string associationType;

    // The sorting options for loading the association
    protected string sort;

    /**
     * Copies the options array to properties in this class. The keys in the array correspond
     * to properties in this class.
     *
     * @param array<string, mixed> options Properties to be copied to this class
     * /
    this(STRINGAA someOptions) {
        this.alias = options["alias"];
        this.sourceAlias = options["sourceAlias"];
        this.targetAlias = options["targetAlias"];
        this.foreignKey = options["foreignKey"];
        this.strategy = options["strategy"];
        this.bindingKey = options["bindingKey"];
        this.finder = options["finder"];
        this.associationType = options["associationType"];
        this.sort = options["sort"] ?? null;
    }

    /**
     * Returns a callable that can be used for injecting association results into a given
     * iterator. The options accepted by this method are the same as `Association::eagerLoader()`
     *
     * @param array<string, mixed> options Same options as `Association::eagerLoader()`
     * @return \Closure
     * /
    function buildEagerLoader(STRINGAA someOptions): Closure
    {
        options += _defaultOptions();
        fetchQuery = _buildQuery(options);
        resultMap = _buildResultMap(fetchQuery, options);

        return _resultInjector(fetchQuery, resultMap, options);
    }

    /**
     * Returns the default options to use for the eagerLoader
     *
     * @return array<string, mixed>
     * /
    protected array _defaultOptions() {
        return [
            "foreignKey": this.foreignKey,
            "conditions": [],
            "strategy": this.strategy,
            "nestKey": this.alias,
            "sort": this.sort,
        ];
    }

    /**
     * Auxiliary function to construct a new Query object to return all the records
     * in the target table that are associated to those specified in options from
     * the source table
     *
     * @param array<string, mixed> options options accepted by eagerLoader()
     * @return DORMQuery
     * @throws \InvalidArgumentException When a key is required for associations but not selected.
     * /
    protected function _buildQuery(STRINGAA someOptions): Query
    {
        key = _linkField(options);
        filter = options["keys"];
        useSubquery = options["strategy"] == Association::STRATEGY_SUBQUERY;
        finder = this.finder;
        options["fields"] = options["fields"] ?? [];

        /** @var DORMQuery query * /
        query = finder();
        if (isset(options["finder"])) {
            [finderName, opts] = _extractFinder(options["finder"]);
            query = query.find(finderName, opts);
        }

        fetchQuery = query
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

        if (!empty(options["sort"])) {
            fetchQuery.order(options["sort"]);
        }

        if (!empty(options["contain"])) {
            fetchQuery.contain(options["contain"]);
        }

        if (!empty(options["queryBuilder"])) {
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
     * query.contain(["Comments": ["finder": ["translations": []]]]);
     * query.contain(["Comments": ["finder": ["translations": ["locales": ["en_US"]]]]]);
     *
     * @param array|string finderData The finder name or an array having the name as key
     * and options as value.
     * /
    protected array _extractFinder(finderData) {
        finderData = (array)finderData;

        if (key(finderData).isNumeric) {
            return [current(finderData), []];
        }

        return [key(finderData), current(finderData)];
    }

    /**
     * Checks that the fetching query either has auto fields on or
     * has the foreignKey fields selected.
     * If the required fields are missing, throws an exception.
     *
     * @param DORMQuery fetchQuery The association fetching query
     * @param array<string> key The foreign key fields to check
     * @return void
     * @throws \InvalidArgumentException
     * /
    protected void _assertFieldsPresent(Query fetchQuery, array key) {
        if (fetchQuery.isAutoFieldsEnabled()) {
            return;
        }

        select = fetchQuery.aliasFields(fetchQuery.clause("select"));
        if (empty(select)) {
            return;
        }
        missingKey = function (fieldList, key) {
            foreach (key as keyField) {
                if (!in_array(keyField, fieldList, true)) {
                    return true;
                }
            }

            return false;
        };

        missingFields = missingKey(select, key);
        if (missingFields) {
            driver = fetchQuery.getConnection().getDriver();
            quoted = array_map([driver, "quoteIdentifier"], key);
            missingFields = missingKey(select, quoted);
        }

        if (missingFields) {
            throw new DInvalidArgumentException(
                sprintf(
                    "You are required to select the '%s' field(s)",
                    implode(", ", key)
                )
            );
        }
    }

    /**
     * Appends any conditions required to load the relevant set of records in the
     * target table query given a filter key and some filtering values when the
     * filtering needs to be done using a subquery.
     *
     * @param DORMQuery query Target table"s query
     * @param array<string>|string aKey the fields that should be used for filtering
     * @param DORMQuery subquery The Subquery to use for filtering
     * @return DORMQuery
     * /
    protected function _addFilteringJoin(Query query, key, subquery): Query
    {
        filter = null;
        aliasedTable = this.sourceAlias;

        foreach (subquery.clause("select") as aliasedField: field) {
            if (is_int(aliasedField)) {
                filter[] = new IdentifierExpression(field);
            } else {
                filter[aliasedField] = field;
            }
        }
        subquery.select(filter, true);

        if ((key.isArray) {
            conditions = _createTupleCondition(query, key, filter, "=");
        } else {
            filter = current(filter);
            conditions = query.newExpr([key: filter]);
        }

        return query.innerJoin(
            [aliasedTable: subquery],
            conditions
        );
    }

    /**
     * Appends any conditions required to load the relevant set of records in the
     * target table query given a filter key and some filtering values.
     *
     * @param DORMQuery query Target table"s query
     * @param array<string>|string aKey The fields that should be used for filtering
     * @param mixed filter The value that should be used to match for key
     * @return DORMQuery
     * /
    protected function _addFilteringCondition(Query query, key, filter): Query
    {
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
     * @param array<string> keys the fields that should be used for filtering
     * @param mixed filter the value that should be used to match for key
     * @param string operator The operator for comparing the tuples
     * @return DORMdatabases.Expression\TupleComparison
     * /
    protected function _createTupleCondition(Query query, array keys, filter, operator): TupleComparison
    {
        types = null;
        defaults = query.getDefaultTypes();
        foreach (keys as k) {
            if (isset(defaults[k])) {
                types[] = defaults[k];
            }
        }

        return new TupleComparison(keys, filter, types, operator);
    }

    /**
     * Generates a string used as a table field that contains the values upon
     * which the filter should be applied
     *
     * @param array<string, mixed> options The options for getting the link field.
     * @return array<string>|string
     * @throws \RuntimeException
     * /
    protected function _linkField(STRINGAA someOptions) {
        links = null;
        name = this.alias;

        if (options["foreignKey"] == false && this.associationType == Association::ONE_TO_MANY) {
            msg = "Cannot have foreignKey = false for hasMany associations~ " ~
                   "You must provide a foreignKey column.";
            throw new RuntimeException(msg);
        }

        keys = in_array(this.associationType, [Association::ONE_TO_ONE, Association::ONE_TO_MANY], true) ?
            this.foreignKey :
            this.bindingKey;

        foreach ((array)keys as key) {
            links[] = sprintf("%s.%s", name, key);
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
     *
     * @param DORMQuery query the original query used to load source records
     * @return DORMQuery
     * /
    protected function _buildSubquery(Query query): Query
    {
        filterQuery = clone query;
        filterQuery.disableAutoFields();
        filterQuery.mapReduce(null, null, true);
        filterQuery.formatResults(null, true);
        filterQuery.contain([], true);
        filterQuery.setValueBinder(new ValueBinder());

        // Ignore limit if there is no order since we need all rows to find matches
        if (!filterQuery.clause("limit") || !filterQuery.clause("order")) {
            filterQuery.limit(null);
            filterQuery.order([], true);
            filterQuery.offset(null);
        }

        fields = _subqueryFields(query);
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
     * @return array<string, array> The list of fields for the subquery.
     * /
    protected array _subqueryFields(Query query) {
        keys = (array)this.bindingKey;

        if (this.associationType == Association::MANY_TO_ONE) {
            keys = (array)this.foreignKey;
        }

        fields = query.aliasFields(keys, this.sourceAlias);
        group = fields = array_values(fields);

        order = query.clause("order");
        if (order) {
            columns = query.clause("select");
            order.iterateParts(void (direction, field) use (&fields, columns) {
                if (isset(columns[field])) {
                    fields[field] = columns[field];
                }
            });
        }

        return ["select": fields, "group": group];
    }

    /**
     * Builds an array containing the results from fetchQuery indexed by
     * the foreignKey value corresponding to this association.
     *
     * @param DORMQuery fetchQuery The query to get results from
     * @param array<string, mixed> options The options passed to the eager loader
     * @return array<string, mixed>
     * /
    protected array _buildResultMap(Query fetchQuery, STRINGAA someOptions) {
        resultMap = null;
        singleResult = in_array(this.associationType, [Association::MANY_TO_ONE, Association::ONE_TO_ONE], true);
        keys = in_array(this.associationType, [Association::ONE_TO_ONE, Association::ONE_TO_MANY], true) ?
            this.foreignKey :
            this.bindingKey;
        key = (array)keys;

        foreach (fetchQuery.all() as result) {
            values = null;
            foreach (key as k) {
                values[] = result[k];
            }
            if (singleResult) {
                resultMap[implode(";", values)] = result;
            } else {
                resultMap[implode(";", values)][] = result;
            }
        }

        return resultMap;
    }

    /**
     * Returns a callable to be used for each row in a query result set
     * for injecting the eager loaded rows
     *
     * @param DORMQuery fetchQuery the Query used to fetch results
     * @param array<string, mixed> resultMap an array with the foreignKey as keys and
     * the corresponding target table results as value.
     * @param array<string, mixed> options The options passed to the eagerLoader method
     * @return \Closure
     * /
    protected function _resultInjector(Query fetchQuery, array resultMap, STRINGAA someOptions): Closure
    {
        keys = this.associationType == Association::MANY_TO_ONE ?
            this.foreignKey :
            this.bindingKey;

        someSourceKeys = null;
        foreach ((array)keys as key) {
            f = fetchQuery.aliasField(key, this.sourceAlias);
            someSourceKeys[] = key(f);
        }

        nestKey = options["nestKey"];
        if (count(someSourceKeys) > 1) {
            return _multiKeysInjector(resultMap, someSourceKeys, nestKey);
        }

        sourceKey = someSourceKeys[0];

        return function (row) use (resultMap, sourceKey, nestKey) {
            if (isset(row[sourceKey], resultMap[row[sourceKey]])) {
                row[nestKey] = resultMap[row[sourceKey]];
            }

            return row;
        };
    }

    /**
     * Returns a callable to be used for each row in a query result set
     * for injecting the eager loaded rows when the matching needs to
     * be done with multiple foreign keys
     *
     * @param array<string, mixed> resultMap A keyed arrays containing the target table
     * someSourceKeys - An array with aliased keys to match
     * @param string nestKey The key under which results should be nested
     * /
    protected Closure _multiKeysInjector(array resultMap, string[] someSourceKeys, string nestKey) {
        return function (row) use (resultMap, someSourceKeys, nestKey) {
            values = null;
            foreach (someSourceKeys as key) {
                values[] = row[key];
            }

            key = implode(";", values);
            if (isset(resultMap[key])) {
                row[nestKey] = resultMap[key];
            }

            return row;
        };
    } */
}
