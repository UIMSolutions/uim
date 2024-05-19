/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.datasources.mixins.query;

@safe:
import uim.datasources;

/**
 * Contains the characteristics for an object that is attached to a repository and
 * can retrieve results based on any criteria.
 */
mixin template TQuery() {
    // Instance of a table object this query is bound to
    protected IRepository _repository;

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

    /**
     * A query cacher instance if this query has caching enabled.
     */
    protected QueryCacher _cache;

    /**
     * Set the default Table object that will be used by this query
     * and form the `FROM` clause.
     *
     * @param uim.Datasource\IRepository|uim.orm.Table repository The default table object to use
     */
    void repository(IRepository repository) {
        _repository = repository;
    }

    /**
     * Returns the default table object that will be used by this query,
     * that is, the table that will appear in the from clause.
     */
    IRepository getRepository() {
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
     * a result set instead of the query itself.
     */
    IResultset getIterator() {
        return _all();
    }

    /**
     * Enable result caching for this query.
     *
     * If a query has caching enabled, it will do the following when executed:
     *
     * - Check the cache for key. If there are results no SQL will be executed.
     *   Instead the cached results will be returned.
     * - When the cached data is stale/missing the result set will be cached as the query
     *   is executed.
     *
     * ### Usage
     *
     * Simple string key + config
     * query.cache("_key", "db_results");
     *
     */ Function to generate key.
     * query.cache(function (q) {
     *   key = serialize(q.clause("select"));
     *   key ~= serialize(q.clause("where"));
     *   return md5(key);
     * });
     *
     */ Using a pre-built cache engine.
     * query.cache("_key", engine);
     *
     */ Disable caching
     * query.cache(false);
     *
     * @param \Closure|string|false key Either the cache key or a function to generate the cache key.
     *   When using a function, this query instance will be supplied as an argument.
     * @param \Psr\SimpleCache\ICache|string myConfiguration Either the name of the cache config to use, or
     *   a cache engine instance.
     */
    void cache(key, myConfiguration = "default") {
        if (key == false) {
            _cache = null;

            return this;
        }
        _cache = new DQueryCacher(key, myConfiguration);
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
     *
     * @param string field The field to alias
     * @param string alias the alias used to prefix the field
     */
    STRINGAA aliasField(string fieldName, string aliasName = null) {
        if (indexOf(field, ".") == false) {
            alias = alias ?: getRepository().aliasName();
            aliasedField = alias ~ "." ~ field;
        } else {
            aliasedField = field;
            [alias, field] = explode(".", field);
        }

        key = "%s__%s".format(alias, field);

        return [key: aliasedField];
    }

    /**
     * Runs `aliasField()` for each field in the provided list and returns
     * the result under a single array.
     *
     * @param Json[string] fields The fields to alias
     * @param string defaultAlias The default alias
     */
    STRINGAA aliasFields(string[] fieldNames, string defaultAlias = null) {
        aliased = null;
        foreach (fields as alias: field) {
            if (alias.isNumeric && field.isString) {
                aliased += this.aliasField(field, defaultAlias);
                continue;
            }
            aliased[alias] = field;
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
    IResultset all() {
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
    Json[string] toDataArray() {
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
     *
     * @param callable|null mapper The mapper callable.
     * @param callable|null reducer The reducing function.
     * @param bool canOverwrite Set to true to overwrite existing map + reduce functions.
     */
    function mapReduce(?callable mapper = null, callable reducer = null, bool canOverwrite = false) {
        if (canOverwrite) {
            _mapReduce = null;
        }
        if (mapper == null) {
            if (!canOverwrite) {
                throw new DInvalidArgumentException("mapper can be null only when canOverwrite is true.");
            }

            return;
        }
        _mapReduce ~= compact("mapper", "reducer");
    }

    /**
     * Returns the list of previously registered map reduce routines.
     */
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
     *     return results.indexBy("id");
     * });
     * ```
     *
     * Add a new column to the Resultset:
     *
     * ```
     * query.select(["name", "birth_date"]).formatResults(function (results) {
     *     return results.map(function (row) {
     *         row["age"] = row["birth_date"].diff(new DateTime).y;
     *
     *         return row;
     *     });
     * });
     * ```
     *
     * Add a new column to the results with respect to the query"s hydration configuration:
     *
     * ```
     * query.formatResults(function (results, query) {
     *     return results.map(function (row) use (query) {
     *         data = [
     *             "bar": "baz",
     *         ];
     *
     *         if (query.isHydrationEnabled()) {
     *             row["foo"] = new DFoo(data)
     *         } else {
     *             row["foo"] = data;
     *         }
     *
     *         return row;
     *     });
     * });
     * ```
     *
     * Retaining access to the association target query instance of joined associations,
     * by inheriting the contain callback"s query argument:
     *
     */ Assuming a `Articles belongsTo Authors` association that uses the join strategy
     *
     * articlesQuery.contain("Authors", function (authorsQuery) {
     *     return authorsQuery.formatResults(function (results, query) use (authorsQuery) {
     *         // Here `authorsQuery` will always be the instance
     *         // where the callback was attached to.
     *
     *         // The instance passed to the callback in the second
     *         // argument (`query`), will be the one where the
     *         // callback is actually being applied to, in this
     *         // example that would be `articlesQuery`.
     *
     *         // ...
     *
     *         return results;
     *     });
     * });
     *
     * @param callable|null formatter The formatting callable.
     * @param int|bool mode Whether to overwrite, append or prepend the formatter.
     */
    void formatResults(?callable formatter = null, mode = self.APPEND) {
        if (mode == self.OVERWRITE) {
            _formatters = null;
        }
        if (formatter == null) {
            if (mode != self.OVERWRITE) {
                throw new DInvalidArgumentException("formatter can be null only when mode is overwrite.");
            }

            return;
        }

        if (mode == self.PREPEND) {
            array_unshift(_formatters, formatter);

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
     *  query.applyOptions(["doABarrelRoll": true.toJson, "fields": ["id", "name"]);
     *  query.getOptions(); // Returns ["doABarrelRoll": true.toJson]
     * ```
     */
    Json[array] getOptions() {
        return _options;
    }

    /**
     * Enables calling methods from the result set as if they were from this class
     *
     * @param string method the method to call
     * @param Json[string] arguments list of arguments for the method to call
     */
    Json __call(string method, Json[string] arguments) {
        resultSetClass = _decoratorClass();
        if (hasAllValues(method, get_class_methods(resultSetClass), true)) {
            deprecationWarning(format(
                "Calling `%s` methods, such as `%s()`, on queries is deprecated~ " ~
                "You must call `all()` first (for example, `all().%s()`).",
                IResultset.class,
                method,
                method,
            ), 2);
            results = this.all();

            return results.method(...arguments);
        }
        throw new BadMethodCallException(
            "Unknown method '%s'".format(method)
        );
    }

    /**
     * Populates or adds parts to current query clauses using an array.
     * This is handy for passing all query clauses at once.
     *
     * @param Json[string] options the options to be applied
     */
    abstract void applyOptions(Json[string] optionData);

    // Executes this query and returns a traversable object containing the results
    abstract protected IResultset _execute();

    /**
     * Decorates the results iterator with MapReduce routines and formatters
     *
     * @param \Traversable result Original results
     */
    protected IResultset _decorateResults(Traversable result) {
        decorator = _decoratorClass();
        foreach (_mapReduce as functions) {
            result = new DMapReduce(result, functions["mapper"], functions["reducer"]);
        }

        if (!_mapReduce.isEmpty) {
            result = new decorator(result);
        }

        foreach (_formatters as formatter) {
            result = formatter(result, this);
        }

        if (!_formatters.isEmpty && !(result instanceof decorator)) {
            result = new decorator(result);
        }

        return result;
    }

    // Returns the name of the class to be used for decorating results
    protected string _decoratorClass() {
        return ResultsetDecorator.className;
    } 
}
