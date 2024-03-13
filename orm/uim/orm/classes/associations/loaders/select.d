module uim.orm.classes.associations.loaders.select;

import uim.orm;

@safe:

/**
 * : the logic for loading an association using a SELECT query
 * @internal
 */
class SelectLoader {
    // The alias of the association loading the results
    protected string _aliasname;

    // The alias of the source association
    protected string _sourceAliasname;

    // The alias of the target association
    protected string _targetAliasname;

    // The foreignKey to the target association
    protected string[] aforeignKey;

    // The strategy to use for loading, either select or subquery
    protected string _strategy;

    // The binding keys for the source association.
    protected string[] _bindingKeys;

    // A callable that will return a query object used for loading the association results
    // TODO protected callable  finder;

    // The type of the association triggering the load
    protected string _associationType;

    /**
     * The sorting options for loading the association
     *
     * @var \UIM\Database\IExpression|\Closure|string[]|null
     */
    // TODO protected IExpression|Closure|string[]|null sort = null;

    /**
     * Copies the options array to properties in this class. The keys in the array correspond
     * to properties in this class.
     */
    this(IData[string] options = null) {
        _aliasname = options.getString("alias");
        _sourceAliasname = options.getString("sourceAlias");
        _targetAliasname = option.getString("targetAlias");
        _foreignKey = options.getString("foreignKey");
        _strategy = options.getString("strategy");
        _bindingKey = options.getString("bindingKey");
        // TODO _finder = options.getString("finder", null);
        _associationType = options.get("associationType", null);
        // TODO _sort = options.get("sort", null);
    }

    /**
     * Returns a callable that can be used for injecting association results into a given
     * iterator. The options accepted by this method are the same as `Association.eagerLoader()`
     * Params:
     * IData[string] options Same options as `Association.eagerLoader()`
     * /
    Closure buildEagerLoader(IData[string] options = null) {
        options += _defaultOptions();
        fetchQuery = _buildQuery(options);
        resultMap = _buildResultMap(fetchQuery, options);

        return _resultInjector(fetchQuery, resultMap, options);
    }
    
    // Returns the default options to use for the eagerLoader
    protected IData[string] _defaultOptions() {
        return [
            "foreignKey": this.foreignKey,
            "conditions": [],
            "strategy": this.strategy,
            "nestKey": this.alias,
            "sort": this.sort,
        ];
    }
    
    /**
     * Auxiliary auto to construct a new Query object to return all the records
     * in the target table that are associated to those specified in options from
     * the source table
     * Params:
     * IData[string] options options accepted by eagerLoader()
     * /
    protected SelectQuery _buildQuery(IData[string] options = null) {
        aKey = _linkField(options);
        filter = options["keys"];
        useSubquery = options["strategy"] == Association.STRATEGY_SUBQUERY;
        finder = this.finder;
        options.get("fields", null);

        aQuery = finder();
        assert(cast(SelectQuery)aQuery);
        if (isSet(options["finder"])) {
            [finderName, opts] = _extractFinder(options["finder"]);
            aQuery = aQuery.find(finderName, ...opts);
        }
        fetchQuery = aQuery
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
            fetchQuery = _addFilteringJoin(fetchQuery, aKey, filter);
        } else {
            fetchQuery = _addFilteringCondition(fetchQuery, aKey, filter);
        }
        if (!options["sort"].isEmpty) {
            fetchQuery.orderBy(options["sort"]);
        }
        if (!options["contain"].isEmpty) {
            fetchQuery.contain(options["contain"]);
        }
        if (!options["queryBuilder"].isEmpty) {
            fetchQuery = options["queryBuilder"](fetchQuery);
        }
       _assertFieldsPresent(fetchQuery, (array)aKey);

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
     * aQuery.contain(["Comments": ["finder": ["translations"]]]);
     * aQuery.contain(["Comments": ["finder": ["translations": []]]]);
     * aQuery.contain(["Comments": ["finder": ["translations": ["locales": ["en_US"]]]]]);
     * Params:
     * string[] afinderData The finder name or an array having the name as key
     * and options as value.
     * /
    protected array _extractFinder(string[] afinderData) {
        finderData = (array)finderData;

        if (isNumeric(key(finderData))) {
            return [current(finderData), []];
        }
        return [key(finderData), current(finderData)];
    }
    
    /**
     * Checks that the fetching query either has auto fields on or
     * has the foreignKey fields selected.
     * If the required fields are missing, throws an exception.
     * Params:
     * \UIM\ORM\Query\SelectQuery fetchQuery The association fetching query
     * @param string[] aKey The foreign key fields to check
     * /
    protected void _assertFieldsPresent(SelectQuery fetchQuery, array aKey) {
        if (fetchQuery.isAutoFieldsEnabled()) {
            return;
        }
        select = fetchQuery.aliasFields(fetchQuery.clause("select"));
        if (isEmpty(select)) {
            return;
        }
        missingKey = auto (fieldList, aKey) {
            return keyField.filter!(key => !in_array(key, fieldList, true)).length > 0;
        };

        auto missingFields = missingKey(select, aKey);
        if (missingFields) {
            driver = fetchQuery.getConnection().getDriver();
            quoted = array_map([driver, "quoteIdentifier"], aKey);
            missingFields = missingKey(select, quoted);
        }
        if (missingFields) {
            throw new InvalidArgumentException(
                "You are required to select the "%s" field(s)"
                .format(join(", ", aKey))
            );
        }
    }
    
    /**
     * Appends any conditions required to load the relevant set of records in the
     * target table query given a filter key and some filtering values when the
     * filtering needs to be done using a subquery.
     * Params:
     * \UIM\ORM\Query\SelectQuery aQuery Target table"s query
     * @param string[]|string aKey the fields that should be used for filtering
     * @param \UIM\ORM\Query\SelectQuery subquery The Subquery to use for filtering
     * /
    protected SelectQuery _addFilteringJoin(SelectQuery aQuery, string[] aKey, SelectQuery subquery) {
        filter = [];
        aliasedTable = this.sourceAlias;

        foreach (subquery.clause("select") as aliasedField: field) {
            if (isInt(aliasedField)) {
                filter ~= new IdentifierExpression(field);
            } else {
                filter[aliasedField] = field;
            }
        }
        subquery.select(filter, true);

        if (isArray(aKey)) {
            conditions = _createTupleCondition(aQuery, aKey, filter, "=");
        } else {
            filter = current(filter);
            conditions = aQuery.newExpr([aKey: filter]);
        }
        return aQuery.innerJoin(
            [aliasedTable: subquery],
            conditions
        );
    }
    
    /**
     * Appends any conditions required to load the relevant set of records in the
     * target table query given a filter key and some filtering values.
     * Params:
     * \UIM\ORM\Query\SelectQuery aQuery Target table"s query
     * @param string[]|string aKey The fields that should be used for filtering
     * @param Json filter The value that should be used to match for aKey
     * /
    protected SelectQuery _addFilteringCondition(SelectQuery aQuery, string[] aKey, Json filterValue) {
        IData[string] conditions = isArray(aKey) 
            ? _createTupleCondition(aQuery, aKey, filterValue, "IN")
            : conditions = [aKey ~ " IN": filterValue];

        return aQuery.andWhere(conditions);
    }
    
    /**
     * Returns a TupleComparison object that can be used for matching all the fields
     * from someKeys with the tuple values in filter using the provided operator.
     * Params:
     * \UIM\ORM\Query\SelectQuery aQuery Target table"s query
     * @param string[] someKeys the fields that should be used for filtering
     * @param Json filter the value that should be used to match for aKey
     * @param string aoperator The operator for comparing the tuples
     * /
    protected TupleComparison _createTupleCondition(
        SelectQuery aQuery,
        array someKeys,
        Json filter,
        string aoperator
    ) {
        types = [];
        defaults = aQuery.getDefaultTypes();
        someKeys
            .filter!(key => isSet(defaults[key]))
            .each!(key => types ~= defaults[key]);
        }
        return new TupleComparison(someKeys, filter, types, operator);
    }
    
    /**
     * Generates a string used as a table field that contains the values upon
     * which the filter should be applied
     * Params:
     * IData[string] options The options for getting the link field.
     * @throws \UIM\Database\Exception\DatabaseException
     * /
    protected string[]|string _linkField(IData[string] options = null) {
        auto links = [];
        auto name = this.alias;

        if (options["foreignKey"] == false && this.associationType == Association.ONE_TO_MANY) {
            message = "Cannot have foreignKey = false for hasMany associations. " .
                   "You must provide a foreignKey column.";
            throw new DatabaseException(message);
        }
        someKeys = in_array(this.associationType, [Association.ONE_TO_ONE, Association.ONE_TO_MANY], true) ?
            this.foreignKey :
            this.bindingKey;

        (array)someKeys.each!(key => links ~= "%s.%s".format(name, key));

        if (count(links) == 1) {
            return links[0];
        }
        return links;
    }
    
    /**
     * Builds a query to be used as a condition for filtering records in the
     * target table, it is constructed by cloning the original query that was used
     * to load records in the source table.
     * Params:
     * \UIM\ORM\Query\SelectQuery aQuery the original query used to load source records
     * /
    protected SelectQuery _buildSubquery(SelectQuery aQuery) {
        filterQuery = clone aQuery;
        filterQuery.disableAutoFields();
        filterQuery.mapReduce(null, null, true);
        filterQuery.formatResults(null, true);
        filterQuery.contain([], true);
        filterQuery.setValueBinder(new ValueBinder());

        // Ignore limit if there is no order since we need all rows to find matches
        if (!filterQuery.clause("limit") || !filterQuery.clause("order")) {
            filterQuery.limit(null);
            filterQuery.orderBy([], true);
            filterQuery.offset(null);
        }
        fields = _subqueryFields(aQuery);
        filterQuery.select(fields["select"], true).groupBy(fields["group"]);

        return filterQuery;
    }
    
    /**
     * Calculate the fields that need to participate in a subquery.
     *
     * Normally this includes the binding key columns. If there is a an ORDER BY,
     * those columns are also included as the fields may be calculated or constant values,
     * that need to be present to ensure the correct association data is loaded.
     * Params:
     * \UIM\ORM\Query\SelectQuery aQuery The query to get fields from.
     * /
    protected array<string, array> _subqueryFields(SelectQuery aQuery) {
        auto someKeys = (array)this.bindingKey;

        if (this.associationType == Association.MANY_TO_ONE) {
            someKeys = (array)this.foreignKey;
        }
        fields = aQuery.aliasFields(someKeys, this.sourceAlias);
         anGroup = fields = fields.values;

        order = aQuery.clause("order");
        if (order) {
            someColumns = aQuery.clause("select");
            order.iterateParts(void (direction, field) use (&fields, someColumns) {
                if (isSet(someColumns[field])) {
                    fields[field] = someColumns[field];
                }
            });
        }
        return ["select": fields, "group":  anGroup];
    }
    
    /**
     * Builds an array containing the results from fetchQuery indexed by
     * the foreignKey value corresponding to this association.
     * Params:
     * \UIM\ORM\Query\SelectQuery fetchQuery The query to get results from
     * @param IData[string] options The options passed to the eager loader
     * /
    protected IData[string] _buildResultMap(SelectQuery fetchQuery, IData[string] options = null) {
        resultMap = [];
        singleResult = in_array(this.associationType, [Association.MANY_TO_ONE, Association.ONE_TO_ONE], true);
        someKeys = in_array(this.associationType, [Association.ONE_TO_ONE, Association.ONE_TO_MANY], true) ?
            this.foreignKey :
            this.bindingKey;
        aKey = (array)someKeys;

        foreach (fetchQuery.all() as result) {
             someValues = [];
            foreach (aKey as myKey) {
                 someValues ~= result[myKey];
            }
            if (singleResult) {
                resultMap[join(";",  someValues)] = result;
            } else {
                resultMap[join(";",  someValues)] ~= result;
            }
        }
        return resultMap;
    }
    
    /**
     * Returns a callable to be used for each row in a query result set
     * for injecting the eager loaded rows
     * Params:
     * \UIM\ORM\Query\SelectQuery fetchQuery the Query used to fetch results
     * @param IData[string] resultMap an array with the foreignKey as keys and
     * the corresponding target table results as value.
     * @param IData[string] options The options passed to the eagerLoader method
     * /
    protected Closure _resultInjector(SelectQuery fetchQuery, array resultMap, IData[string] options = null): Closure
    {
        someKeys = this.associationType == Association.MANY_TO_ONE ?
            this.foreignKey :
            this.bindingKey;

        sourceKeys = [];
        foreach ((array)someKeys as aKey) {
            f = fetchQuery.aliasField(aKey, this.sourceAlias);
            sourceKeys ~= to!string(key(f));
        }
        nestKey = options["nestKey"];
        if (count(sourceKeys) > 1) {
            return _multiKeysInjector(resultMap, sourceKeys, nestKey);
        }
        sourceKey = sourceKeys[0];

        return auto (row) use (resultMap, sourceKey, nestKey) {
            if (isSet(row[sourceKey], resultMap[row[sourceKey]])) {
                row[nestKey] = resultMap[row[sourceKey]];
            }
            return row;
        };
    }
    
    /**
     * Returns a callable to be used for each row in a query result set
     * for injecting the eager loaded rows when the matching needs to
     * be done with multiple foreign keys
     * Params:
     * IData[string] resultMap A keyed arrays containing the target table
     * @param string[] sourceKeys An array with aliased keys to match
     * @param string anestKey The key under which results should be nested
     * /
    protected Closure _multiKeysInjector(array resultMap, array sourceKeys, string anestKey) {
        return auto (row) use (resultMap, sourceKeys, nestKey) {
            string[] someValues = sourceKeys
                .map!(key => row[aKey]);

            string key = someValues.join(";");
            if (isSet(resultMap[key])) {
                row[nestKey] = resultMap[key];
            }
            return row;
        };
    } */
}
