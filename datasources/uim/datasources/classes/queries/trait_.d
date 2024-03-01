/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.datasources.trait_;

@safe:
import uim.datasources;

use BadMethodCallException;
import uim.cake.collections.Iterator\MapReduce;
import uim.datasources.exceptions.RecordNotFoundException;
use InvalidArgumentException;
use Traversable;

/**
 * Contains the characteristics for an object that is attached to a repository and
 * can retrieve results based on any criteria.
 */
trait QueryTrait
{
    /**
     * Instance of a table object this query is bound to
     *
     * @var uim.datasources.IRepository
     */
    protected _repository;

    /**
     * A ResultSet.
     *
     * When set, query execution will be bypassed.
     *
     * @var iterable|null
     * @see uim.datasources.QueryTrait::setResult()
     */
    protected _results;

    /**
     * List of map-reduce routines that should be applied over the query
     * result
     *
     * @var array
     */
    protected _mapReduce = null;

    /**
     * List of formatter classes or callbacks that will post-process the
     * results when fetched
     *
     * @var array<callable>
     */
    protected _formatters = null;

    /**
     * A query cacher instance if this query has caching enabled.
     *
     * @var uim.datasources.QueryCacher|null
     */
    protected _cache;

    /**
     * Holds any custom options passed using applyOptions that could not be processed
     * by any method in this class.
     *
     * @var array
     */
    protected _options = null;

    /**
     * Whether the query is standalone or the product of an eager load operation.
     */
    protected bool _eagerLoaded = false;

    /**
     * Set the default Table object that will be used by this query
     * and form the `FROM` clause.
     *
     * @param uim.cake.Datasource\IRepository|uim.cake.orm.Table repository The default table object to use
     * @return this
     */
    function repository(IRepository repository) {
        _repository = repository;

        return this;
    }

    /**
     * Returns the default table object that will be used by this query,
     * that is, the table that will appear in the from clause.
     *
     * @return uim.cake.Datasource\IRepository
     */
    function getRepository(): IRepository
    {
        return _repository;
    }

    /**
     * Set the result set for a query.
     *
     * Setting the resultset of a query will make execute() a no-op. Instead
     * of executing the SQL query and fetching results, the ResultSet provided to this
     * method will be returned.
     *
     * This method is most useful when combined with results stored in a persistent cache.
     *
     * @param iterable results The results this query should return.
     * @return this
     */
    function setResult(iterable results) {
        _results = results;

        return this;
    }

    /**
     * Executes this query and returns a results iterator. This bool is required
     * for implementing the IteratorAggregate interface and allows the query to be
     * iterated without having to call execute() manually, thus making it look like
     * a result set instead of the query itself.
     *
     * @return uim.cake.Datasource\IResultSet
     * @psalm-suppress ImplementedReturnTypeMismatch
     */
    #[\ReturnTypeWillChange]
    function getIterator() {
        return this.all();
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
     * ```
     * // Simple string key + config
     * query.cache("my_key", "db_results");
     *
     * // Function to generate key.
     * query.cache(function (q) {
     *   key = serialize(q.clause("select"));
     *   key ~= serialize(q.clause("where"));
     *   return md5(key);
     * });
     *
     * // Using a pre-built cache engine.
     * query.cache("my_key", engine);
     *
     * // Disable caching
     * query.cache(false);
     * ```
     *
     * @param \Closure|string|false key Either the cache key or a function to generate the cache key.
     *   When using a function, this query instance will be supplied as an argument.
     * @param \Psr\SimpleCache\ICache|string aConfig Either the name of the cache config to use, or
     *   a cache engine instance.
     * @return this
     */
    function cache(key, aConfig = "default") {
        if (key == false) {
            _cache = null;

            return this;
        }
        _cache = new QueryCacher(key, aConfig);

        return this;
    }

    /**
     * Returns the current configured query `_eagerLoaded` value
     */
    bool isEagerLoaded() {
        return _eagerLoaded;
    }

    /**
     * Sets the query instance to be an eager loaded query. If no argument is
     * passed, the current configured query `_eagerLoaded` value is returned.
     *
     * @param bool value Whether to eager load.
     * @return this
     */
    function eagerLoaded(bool value) {
        _eagerLoaded = value;

        return this;
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
     * @param string|null alias the alias used to prefix the field
     */
    STRINGAA aliasField(string field, Nullable!string alias = null) {
        if (strpos(field, ".") == false) {
            alias = alias ?: this.getRepository().getAlias();
            aliasedField = alias ~ "." ~ field;
        } else {
            aliasedField = field;
            [alias, field] = explode(".", field);
        }

        key = sprintf("%s__%s", alias, field);

        return [key: aliasedField];
    }

    /**
     * Runs `aliasField()` for each field in the provided list and returns
     * the result under a single array.
     *
     * @param array fields The fields to alias
     * @param string|null defaultAlias The default alias
     */
    STRINGAA aliasFields(array fields, Nullable!string defaultAlias = null) {
        aliased = null;
        foreach (fields as alias: field) {
            if (is_numeric(alias) && is_string(field)) {
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
     * and return the ResultSetDecorator object ready for streaming of results.
     *
     * ResultSetDecorator is a traversable object that : the methods found
     * on Cake\collections.Collection.
     *
     * @return uim.cake.Datasource\IResultSet
     */
    function all(): IResultSet
    {
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
    array toArray() {
        return this.all().toArray();
    }

    /**
     * Register a new MapReduce routine to be executed on top of the database results
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
     * @return this
     * @see uim.cake.collections.Iterator\MapReduce for details on how to use emit data to the map reducer.
     */
    function mapReduce(?callable mapper = null, ?callable reducer = null, bool canOverwrite = false) {
        if (canOverwrite) {
            _mapReduce = null;
        }
        if (mapper == null) {
            if (!canOverwrite) {
                throw new InvalidArgumentException("mapper can be null only when canOverwrite is true.");
            }

            return this;
        }
        _mapReduce[] = compact("mapper", "reducer");

        return this;
    }

    /**
     * Returns the list of previously registered map reduce routines.
     */
    array getMapReducers() {
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
     * implementing `uim.cake.collections.ICollection`, that can be traversed and
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
     * Add a new column to the ResultSet:
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
     *             row["foo"] = new Foo(data)
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
     * ```
     * // Assuming a `Articles belongsTo Authors` association that uses the join strategy
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
     * ```
     *
     * @param callable|null formatter The formatting callable.
     * @param int|bool mode Whether to overwrite, append or prepend the formatter.
     * @return this
     * @throws \InvalidArgumentException
     */
    function formatResults(?callable formatter = null, mode = self::APPEND) {
        if (mode == self::OVERWRITE) {
            _formatters = null;
        }
        if (formatter == null) {
            if (mode != self::OVERWRITE) {
                throw new InvalidArgumentException("formatter can be null only when mode is overwrite.");
            }

            return this;
        }

        if (mode == self::PREPEND) {
            array_unshift(_formatters, formatter);

            return this;
        }

        _formatters[] = formatter;

        return this;
    }

    /**
     * Returns the list of previously registered format routines.
     *
     * @return array<callable>
     */
    function getResultFormatters() {
        return _formatters;
    }

    /**
     * Returns the first result out of executing this query, if the query has not been
     * executed before, it will set the limit clause to 1 for performance reasons.
     *
     * ### Example:
     *
     * ```
     * singleUser = query.select(["id", "username"]).first();
     * ```
     *
     * @return uim.cake.Datasource\IEntity|array|null The first result from the ResultSet.
     */
    function first() {
        if (_isDirty) {
            this.limit(1);
        }

        return this.all().first();
    }

    /**
     * Get the first result from the executing query or raise an exception.
     *
     * @throws uim.cake.Datasource\exceptions.RecordNotFoundException When there is no first record.
     * @return uim.cake.Datasource\IEntity|array The first result from the ResultSet.
     */
    function firstOrFail() {
        entity = this.first();
        if (!entity) {
            table = this.getRepository();
            throw new RecordNotFoundException(sprintf(
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
     *  query.applyOptions(["doABarrelRoll": true, "fields": ["id", "name"]);
     *  query.getOptions(); // Returns ["doABarrelRoll": true]
     * ```
     *
     * @see uim.datasources.IQuery::applyOptions() to read about the options that will
     * be processed by this class and not returned by this function
     * @return array
     * @see applyOptions()
     */
    array getOptions() {
        return _options;
    }

    /**
     * Enables calling methods from the result set as if they were from this class
     *
     * @param string method the method to call
     * @param array arguments list of arguments for the method to call
     * @return mixed
     * @throws \BadMethodCallException if no such method exists in result set
     */
    function __call(string method, array arguments) {
        resultSetClass = _decoratorClass();
        if (hasAllValues(method, get_class_methods(resultSetClass), true)) {
            deprecationWarning(sprintf(
                "Calling `%s` methods, such as `%s()`, on queries is deprecated~ " ~
                "You must call `all()` first (for example, `all().%s()`).",
                IResultSet::class,
                method,
                method,
            ), 2);
            results = this.all();

            return results.method(...arguments);
        }
        throw new BadMethodCallException(
            sprintf("Unknown method '%s'", method)
        );
    }

    /**
     * Populates or adds parts to current query clauses using an array.
     * This is handy for passing all query clauses at once.
     *
     * @param array<string, mixed> options the options to be applied
     * @return this
     */
    abstract function applyOptions(STRINGAA someOptions);

    /**
     * Executes this query and returns a traversable object containing the results
     *
     * @return uim.cake.Datasource\IResultSet
     */
    abstract protected function _execute(): IResultSet;

    /**
     * Decorates the results iterator with MapReduce routines and formatters
     *
     * @param \Traversable result Original results
     * @return uim.cake.Datasource\IResultSet
     */
    protected function _decorateResults(Traversable result): IResultSet
    {
        decorator = _decoratorClass();
        foreach (_mapReduce as functions) {
            result = new MapReduce(result, functions["mapper"], functions["reducer"]);
        }

        if (!empty(_mapReduce)) {
            result = new decorator(result);
        }

        foreach (_formatters as formatter) {
            result = formatter(result, this);
        }

        if (!empty(_formatters) && !(result instanceof decorator)) {
            result = new decorator(result);
        }

        return result;
    }

    /**
     * Returns the name of the class to be used for decorating results
     *
     * @return string
     * @psalm-return class-string<uim.cake.Datasource\IResultSet>
     */
    protected string _decoratorClass() {
        return ResultSetDecorator::class;
    }
}
