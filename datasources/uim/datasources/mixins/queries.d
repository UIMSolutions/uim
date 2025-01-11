/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.datasources.mixins.queries;

@safe:
import uim.datasources;

/**
 * Contains the characteristics for an object that is attached to a repository and
 * can retrieve results based on any criteria.
 */
mixin template TQuery() {
    // Instance of a table object this query is bound to
    protected IDatasourceRepository _repository;

    // List of map-reduce routines that should be applied over the query result
    protected Json[string] _mapReduce = null;

    // Custom options that could not be processed by any method in this class.
    protected Json[string] _options = null;

    // Whether the query is standalone or the product of an eager load operation.
    protected bool _eagerLoaded = false;

    /**
     * A Resultset.
     * When set, query execution will be bypassed.
     */
    protected iterable _results;

    /**
     * List of formatter classes or callbacks that will post-process the
     * results when fetched
     */
    protected callable[] _formatters = null;

    // A query cacher instance if this query has caching enabled.
    protected QueryCacher _cache;

    /**
     * Set the default Table object that will be used by this query
     * and form the `FROM` clause.
     */
    void repository(IDatasourceRepository repository) {
        _repository = repository;
    }

    /**
     * Returns the default table object that will be used by this query,
     * that is, the table that will appear in the from clause.
     */
    IDatasourceRepository getRepository() {
        return _repository;
    }

    /**
     * Set the result set for a query.
     *
     * Setting the resultset of a query will make execute() a no-op. Instead
     * of executing the SQL query and fetching results, the Resultset provided to this
     * method will be returned.
     *
     * This method is most useful when combined with results stored in a persistent cache.
     */
    void setResult(Json[string] returnResults) {
        _results = returnResults;
    }

    /**
     * Executes this query and returns a results iterator. This bool is required
     * for implementing the IteratorAggregate interface and allows the query to be
     * iterated without having to call execute() manually, thus making it look like
     * a result set instead of the query it
     */
    IDatasourceResultset getIterator() {
        return _all();
    }

    /**
     * Enable result caching for this query.
     *
     * If a query has caching enabled, it will do the following when executed:
     *
     * - Check the cache for key. If there are results no SQL will be executed.
     *  Instead the cached results will be returned.
     * - When the cached data is stale/missing the result set will be cached as the query
     *  is executed.
     *
     * ### Usage
     *
     * Simple string key + config
     * query.cache("_key", "db_results");
     *
     * Function to generate key.
     * query.cache(function (q) {
     *  key = serialize(q.clause("select"));
     *  key ~= serialize(q.clause("where"));
     *  return key.md5;
     * });
     *
     * Using a pre-built cache engine.
     * query.cache("_key", engine);
     *
      Disable caching
     * query.cache(false);
     */
    void cache(/* \Closure */ string cacheKey, string cacheConfigName = "default") {
        _cache = cacheKey.isEmpty
            ? null
            : new DQueryCacher(cacheKey, cacheConfigName);
    }

    // Returns the current configured query `_eagerLoaded` value
    bool isEagerLoaded() {
        return _eagerLoaded;
    }

    /**
     * Sets the query instance to be an eager loaded query. If no argument is
     * passed, the current configured query `_eagerLoaded` value is returned.
     */
    void eagerLoaded(bool value) {
        _eagerLoaded = value;
    }

    /**
     * Returns a key: value array representing a single aliased field
     * that can be passed directly to the select() method.
     * The key will contain the alias and the value the actual field name.
     *
     * If the field is already aliased, then it will not be changed.
     * If no alias is passed, the default table for this query will be used.
     */
    STRINGAA aliasField(string fieldName, string fieldAlias = null) {
        if (indexOf(fieldName, ".") == false) {
            fieldAlias = fieldAlias ? fieldAlias : getRepository().aliasName();
            fieldAlias = fieldAlias ~ "." ~ field;
        } else {
            fieldAlias = field;
            [fieldAlias, field] = explode(".", field);
        }

        auto key = "%s__%s".format(fieldAlias, field);

        return [key: fieldAlias];
    }

    /**
     * Runs `aliasField()` for each field in the provided list and returns
     * the result under a single array.
     */
    STRINGAA aliasFields(string[] fieldAlias, string defaultAlias = null) {
        auto aliased = null;
        foreach (fieldAlias as aliasName: field) {
            if (aliasName.isNumeric && field.isString) {
                aliased += this.aliasField(field, defaultAlias);
                continue;
            }
            aliased[aliasName] = field;
        }

        return aliased;
    }

    /**
     * Fetch the results for this query.
     *
     * Will return either the results set through setResult(), or execute this query
     * and return the ResultsetDecorator object ready for streaming of results.
     *
     * ResultsetDecorator is a traversable object that : the methods found
     * on uim\collections.Collection.
     */
    IDatasourceResultset all() {
        if (_results != null) {
            return _results;
        }

        results = null;
        if (_cache) {
            results = _cache.fetch(this);
        }
        if (results == null) {
            results = _decorateResults(_execute());
            if (_cache) {
                _cache.store(this, results);
            }
        }
        _results = results;

        return _results;
    }

    /**
     * Returns an array representation of the results after executing the query.
     */
    Json[string] toArray() {
        return _all().toJString();
    }

    /**
     * Register a new DMapReduce routine to be executed on top of the database results
     * Both the mapper and caller callable should be invokable objects.
     *
     * The MapReduce routing will only be run when the query is executed and the first
     * result is attempted to be fetched.
     *
     * If the third argument is set to true, it will erase previous map reducers
     * and replace it with the arguments passed.
     */
    void mapReduce(callable mapper = null, callable reducer = null, bool canOverwrite = false) {
        if (canOverwrite) {
            _mapReduce = null;
        }
        if (mapper == null) {
            if (!canOverwrite) {
                throw new DInvalidArgumentException("mapper can be null only when canOverwrite is true.");
            }

            return;
        }
        _mapReduce ~= [
            "mapper": mapper, 
            "reducer": reducer
        ];
    }

    // Returns the list of previously registered map reduce routines.
    Json[string] getMapReducers() {
        return _mapReduce;
    }

    /**
     * Registers a new formatter callback function that is to be executed when trying
     * to fetch the results from the database.
     *
     * If the second argument is set to true, it will erase previous formatters
     * and replace them with the passed first argument.
     *
     * Callbacks are required to return an iterator object, which will be used as
     * the return value for this query"s result. Formatter functions are applied
     * after all the `MapReduce` routines for this query have been executed.
     *
     * Formatting callbacks will receive two arguments, the first one being an object
     * implementing `uim.collections.ICollection`, that can be traversed and
     * modified at will. The second one being the query instance on which the formatter
     * callback is being applied.
     *
     * Usually the query instance received by the formatter callback is the same query
     * instance on which the callback was attached to, except for in a joined
     * association, in that case the callback will be invoked on the association source
     * side query, and it will receive that query instance instead of the one on which
     * the callback was originally attached to - see the examples below!
     *
     * ### Examples:
     *
     * Return all results from the table indexed by id:
     *
     * ```
     * query.select(["id", "name"]).formatResults(function (results) {
     *    return results.indexBy("id");
     * });
     * ```
     *
     * Add a new column to the Resultset:
     *
     * ```
     * query.select(["name", "birth_date"]).formatResults(function (results) {
     *    return results.map(function (row) {
     *        row["age"] = row["birth_date"].diff(new DateTime).y;
     *
     *        return row;
     *    });
     * });
     * ```
     *
     * Add a new column to the results with respect to the query"s hydration configuration:
     *
     * ```
     * query.formatResults(function (results, query) {
     *    return results.map(function (row) use (query) {
     *        data = [
     *            "bar": "baz",
     *        ];
     *
     *        if (query.isHydrationEnabled()) {
     *            row.set("foo", new DFoo(data));
     *        } else {
     *            row.set("foo", data);
     *        }
     *
     *        return row;
     *    });
     * });
     * ```
     *
     * Retaining access to the association target query instance of joined associations,
     * by inheriting the contain callback"s query argument:
     *
     * Assuming a `Articles belongsTo Authors` association that uses the join strategy
     *
     * articlesQuery.contain("Authors", function (authorsQuery) {
     *    return authorsQuery.formatResults(function (results, query) use (authorsQuery) {
     *        // Here `authorsQuery` will always be the instance
     *        // where the callback was attached to.
     *
     *        // The instance passed to the callback in the second
     *        // argument (`query`), will be the one where the
     *        // callback is actually being applied to, in this
     *        // example that would be `articlesQuery`.
     *
     *        // ...
     *
     *        return results;
     *    });
     * });
     */
    void formatResults(callable formatter = null, int mode = APPEND) {
        if (mode == OVERWRITE) {
            _formatters = null;
        }
        if (formatter == null) {
            if (mode != OVERWRITE) {
                throw new DInvalidArgumentException("formatter can be null only when mode is overwrite.");
            }
            return;
        }

        if (mode == PREPEND) {
            _formatters.unshift(formatter);
            return 
        }

        _formatters ~= formatter;
    }

    // Returns the list of previously registered format routines.
    callable[] getResultFormatters() {
        return _formatters;
    }

    /**
     * Returns the first result out of executing this query, if the query has not been
     * executed before, it will set the limit clause to 1 for performance reasons.
     *
     * ### Example:
     *
     * singleUser = query.select(["id", "username"]).first();
     */
    IDatasourceEntity first() {
        if (_isDirty) {
            this.limit(1);
        }

        return _all().first();
    }

    // Get the first result from the executing query or raise an exception.
    IDatasourceEntity firstOrFail() {
        entity = this.first();
        if (!entity) {
            table = getRepository();
            throw new DRecordNotFoundException(format(
                "Record not found in table '%s'",
                table.getTable()
           ));
        }

        return entity;
    }

    /**
     * Returns an array with the custom options that were applied to this query
     * and that were not already processed by another method in this class.
     *
     * ### Example:
     *
     * ```
     * query.applyOptions(["doABarrelRoll": true.toJson, "fields": ["id", "name"]);
     * query.getOptions(); // Returns ["doABarrelRoll": true.toJson]
     * ```
     */
    Json[array] getOptions() {
        return _options;
    }

    // Enables calling methods from the result set as if they were from this class
    Json __call(string methodName, Json[string] methodArguments) {
        resultSetClass = _decoratorClassname();
        if (hasAllValues(methodName, get_class_methods(resultSetClass), true)) {
            deprecationWarning(
                "Calling `%s` methods, such as `%s()`, on queries is deprecated~ " ~
                "You must call `all()` first (for example, `all().%s()`)."
                .format(IDatasourceResultset.classname, methodName, methodName,), 2);
            results = this.all();

            return results.method(...methodArguments);
        }
        throw new BadMethodCallException(
            "Unknown method '%s'".format(methodName)
       );
    }

    /**
     * Populates or adds parts to current query clauses using an array.
     * This is handy for passing all query clauses at once.
     */
    abstract void applyOptions(Json[string] options = null);

    // Executes this query and returns a traversable object containing the results
    abstract protected IDatasourceResultset _execute();

    // Decorates the results iterator with MapReduce routines and formatters
    protected IDatasourceResultset _decorateResults(Traversable originalResults) {
        auto decorator = _decoratorClassname();
        _mapReduce.each!(functions => originalResults = new DMapReduce(originalResults, functions["mapper"], functions["reducer"]));

        if (!_mapReduce.isEmpty) {
            originalResults = new decorator(originalResults);
        }

        _formatters.each!(formatter => originalResults = formatter(originalResults, this));

        if (!_formatters.isEmpty && !(cast(decorator)originalResults)) {
            originalResults = new decorator(originalResults);
        }

        return originalResults;
    }

    // Returns the name of the class to be used for decorating results
    protected string _decoratorClassname() {
        return ResultsetDecorator.classname;
    } 
}
