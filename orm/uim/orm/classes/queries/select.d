module uim.orm.classes.queries.select;

import uim.orm;

@safe:

/**
 * : the UIM\Database\Query\SelectQuery class to provide new methods related to association
 * loading, automatic fields selection, automatic type casting and to wrap results
 * into a specific iterator that will be responsible for hydrating results if
 * required.
 *
 * @template TSubject of \UIM\Datasource\IORMEntity|array
 * @extends \UIM\Database\Query\SelectQuery<TSubject>
 */
class DSelectQuery : DQuery { // , JsonSerializable, IQuery {
    mixin TCommonQuery;
    
    // Indicates that the operation should append to the list
    const int APPEND = 0;

    // Indicates that the operation should prepend to the list
    const int PREPEND = 1;

    // Indicates that the operation should overwrite the list
    const bool OVERWRITE = true;

    /**
     * Whether the user select any fields before being executed, this is used
     * to determined if any fields should be automatically be selected.
     */
    protected bool _hasFields = false;

    /**
     * Tracks whether the original query should include
     * fields from the top level table.
     */
    protected bool _autoFields = false;

    // Whether to hydrate results into entity objects
    protected bool _hydrate = true;

    // Whether the query is standalone or the product of an eager load operation.
    protected bool _eagerLoaded = false;

    // True if the beforeFind event has already been triggered for this query
    protected bool _beforeFindFired = false;
    
   /* 

    /**
     * A callback used to calculate the total amount of
     * records this query will match when not using `limit`
     */
    protected DClosure _counter = null;

    /**
     * Instance of a class responsible for storing association containments and
     * for eager loading them when this query is executed
     */
    protected DEagerLoader _eagerLoader = null;


    /**
     * The COUNT(*) for the query.
     *
     * When set, count query execution will be bypassed.
     */
    protected int _resultsCount = null;

    /**
     * Resultset factory
     * @var \ORM\ResultsetFactory<\UIM\Datasource\IORMEntity|array>
     */
    protected DResultsetFactory resultSetFactory;

    /**
     * A Resultset.
     *
     * When set, SelectQuery execution will be bypassed.
     * @var iterable|null
     */
    protected Json[string] _results = null;

    // List of map-reduce routines that should be applied over the query result
    protected Json[string] _mapReduce = null;

    /**
     * List of formatter classes or callbacks that will post-process the
     * results when fetched
     */
    protected DClosure[] _formatters = null;

    /**
     * A query cacher instance if this query has caching enabled.
     *
     * @var \UIM\Datasource\QueryCacher|null
     */
    protected IQueryCacher _cache = null;

    /**
     * Holds any custom options passed using applyOptions that could not be processed
     * by any method in this class.
     */
    protected Json[string] _options = null;

    /**
     
     * Params:
     * \ORM\Table mytable The table this query is starting on
     */
    this(DTTable mytable) {
        super(mytable.getConnection());

        setRepository(mytable);
        this.addDefaultTypes(mytable);
    }
    
    /**
     * Set the result set for a query.
     *
     * Setting the resultset of a query will make execute() a no-op. Instead
     * of executing the SQL query and fetching results, the Resultset provided to this
     * method will be returned.
     *
     * This method is most useful when combined with results stored in a persistent cache.
     * Params:
     * range results The results this query should return.
     */
    void setResult(Json[string] results) {
       _results = results;
    }
    
    /**
     * Executes this query and returns a results iterator. This bool is required
     * for implementing the IteratorAggregate interface and allows the query to be
     * iterated without having to call execute() manually, thus making it look like
     * a result set instead of the query it
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
     * Instead the cached results will be returned.
     * - When the cached data is stale/missing the result set will be cached as the query
     * is executed.
     *
     * ### Usage
     *
     * ```
     * Simple string key + config
     * myquery.cache("_key", "db_results");
     *
     * auto to generate key.
     * myquery.cache(function (myq) {
     * key = serialize(myq.clause("select"));
     * key ~= serialize(myq.clause("where"));
     * return md5(key);
     * });
     *
     * Using a pre-built cache engine.
     * myquery.cache("_key", myengine);
     *
     * Disable caching
     * myquery.cache(false);
     * ```
     * Params:
     * \/*Closure|* / string key Either the cache key or a auto to generate the cache key.
     * When using a function, this query instance will be supplied as an argument.
     */
    void cache(/*Closure|*/ string key, /* ICache| */string configData = "default") {
        if (key == false) {
           _cache = null;

            return;
        }
       _cache = new DQueryCacher(key, configData);
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
     * Params:
     * bool myvalue Whether to eager load.
     */
    void eagerLoaded(bool myvalue) {
       _eagerLoaded = myvalue;
    }
    
    /**
     * Returns a key: value array representing a single aliased field
     * that can be passed directly to the select() method.
     * The key will contain the alias and the value the actual field name.
     *
     * If the field is already aliased, then it will not be changed.
     * If no aliasName is passed, the default table for this query will be used.
     */
    STRINGAA aliasField(string fieldName, string aliasName = null) {
        if (fieldName.contains(".")) {
            myaliasedField = fieldName;
            [aliasName, fieldName] = fieldName.split(".");
        } else {
            aliasName = aliasName ?: getRepository().aliasName();
            myaliasedField = aliasName ~ "." ~ fieldName;
        }
        
        string key = "%s__%s".format(aliasName, fieldName);
        return [key: myaliasedField];
    }
    
    /**
     * Runs `aliasField()` for each field in the provided list and returns
     * the result under a single array.
     */
    STRINGAA aliasFields(Json[string] fieldNames, string defaultAlias = null) {
        STRINGAA aliased = null;
        foreach (aliasName, fieldName; fieldNames) {
            if (isNumeric(aliasName) && isString(fieldName)) {
                aliased += aliasField(fieldName, defaultAlias);
                continue;
            }
            aliased[aliasName] = fieldName;
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
     * on UIM\Collection\Collection.
     */
    IResultset<mixed> all() {
        if (_results !is null) {
            if (!(cast(IResultset)_results)) {
               _results = _decorateResults(_results);
            }
            return _results;
        }
        results = null;
        if (_cache) {
            results = _cache.fetch(this);
        }
        if (results.isNull) {
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
     *
     * The MapReduce routing will only be run when the query is executed and the first
     * result is attempted to be fetched.
     *
     * If the third argument is set to true, it will erase previous map reducers
     * and replace it with the arguments passed.
     */
    /* void mapReduce(Closure mapperFunc = null, DClosure myreducer = null, bool shouldOverwrite = false) {
        if (shouldOverwrite) {
           _mapReduce = null;
        }
        if (mymapper.isNull) {
            if (!shouldOverwrite) {
                throw new DInvalidArgumentException("mymapper can be null only when shouldOverwrite is true.");
            }
            return;
        }
       _mapReduce ~= compact("mapper", "reducer");
    } */
    
    /**
     * Returns the list of previously registered map reduce routines.
     */
    Json[string]getMapReducers() {
        return _mapReduce;
    }
    
    /**
     * Registers a new formatter callback auto that is to be executed when trying
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
     * implementing `\UIM\Collection\ICollection`, that can be traversed and
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
     * myquery.select(["id", "name"]).formatResults(function (results) {
     *   return results.indexBy("id");
     * });
     * ```
     *
     * Add a new column to the Resultset:
     *
     * ```
     * myquery.select(["name", "birth_date"]).formatResults(function (results) {
     *   return results.map(function (myrow) {
     *       myrow["age"] = myrow["birth_date"].diff(new DateTime).y;
     *
     *       return myrow;
     *   });
     * });
     * ```
     *
     * Add a new column to the results with respect to the query"s hydration configuration:
     *
     * ```
     * myquery.formatResults(function (results, myquery) {
     *   return results.map(function (myrow) use (myquery) {
     *       mydata = [
     *           "bar": "baz",
     *       ];
     *
     *       if (myquery.isHydrationEnabled()) {
     *           myrow["foo"] = new DFoo(mydata)
     *       } else {
     *           myrow["foo"] = mydata;
     *       }
     *
     *       return myrow;
     *   });
     * });
     * ```
     *
     * Retaining access to the association target query instance of joined associations,
     * by inheriting the contain callback"s query argument:
     *
     * ```
     * Assuming a `Articles belongsTo Authors` association that uses the join strategy
     *
     * myarticlesQuery.contain("Authors", auto (myauthorsQuery) {
     *   return myauthorsQuery.formatResults(function (results, myquery) use (myauthorsQuery) {
     *       // Here `myauthorsQuery` will always be the instance
     *       // where the callback was attached to.
     *
     *       // The instance passed to the callback in the second
     *       // argument (`myquery`), will be the one where the
     *       // callback is actually being applied to, in this
     *       // example that would be `myarticlesQuery`.
     *
     *       // ...
     *
     *       return results;
     *   });
     * });
     * ```
     */
    void formatResults(DClosure myformatter = null, int/* bool */ formatterMode = APPEND) {
        if (formatterMode == OVERWRITE) {
           _formatters = null;
        }
        if (myformatter.isNull) {
            if (formatterMode != OVERWRITE) {
                throw new DInvalidArgumentException("myformatter can be null only when formatterMode is overwrite.");
            }
            return;
        }
        if (formatterMode == PREPEND) {
            array_unshift(_formatters, myformatter);

            return 
        }
       _formatters ~= myformatter;
    }
    
    // Returns the list of previously registered format routines.
    Closure[] getResultFormatters() {
        return _formatters;
    }
    
    /**
     * Returns the first result out of executing this query, if the query has not been
     * executed before, it will set the limit clause to 1 for performance reasons.
     *
     * ### Example:
     *
     * ```
     * mysingleUser = myquery.select(["id", "username"]).first();
     * ```
     */
    Json first() {
        if (_isDirty) {
            this.limit(1);
        }
        return _all().first();
    }
    
    // Get the first result from the executing query or raise an exception.
    Json firstOrFail() {
        myentity = this.first();
        if (!myentity) {
            mytable = getRepository();
            throw new DRecordNotFoundException(
                "Record not found in table `%s`.",
                .format(mytable.getTable()
           ));
        }
        return myentity;
    }
    
    /**
     * Returns an array with the custom options that were applied to this query
     * and that were not already processed by another method in this class.
     *
     * ### Example:
     *
     * ```
     * myquery.applyOptions(["doABarrelRoll": true.toJson, "fields": ["id", "name"]);
     * myquery.getOptions(); // Returns ["doABarrelRoll": true.toJson]
     * ```
     */
    Json[string] getOptions() {
        return _options;
    }
    
    /**
     * Populates or adds parts to current query clauses using an array.
     * This is handy for passing all query clauses at once.
     *
     * The method accepts the following query clause related options:
     *
     * - fields: Maps to the select method
     * - conditions: Maps to the where method
     * - limit: Maps to the limit method
     * - order: Maps to the order method
     * - offset: Maps to the offset method
     * - group: Maps to the group method
     * - having: Maps to the having method
     * - contain: Maps to the contain options for eager loading
     * - join: Maps to the join method
     * - page: Maps to the page method
     *
     * All other options will not affect the query, but will be stored
     * as custom options that can be read via `getOptions()`. Furthermore
     * they are automatically passed to `Model.beforeFind`.
     *
     * ### Example:
     *
     * ```
     * myquery.applyOptions([
     * "fields": ["id", "name"],
     * "conditions": [
     *   "created >=": "2013-01-01"
     * ],
     * "limit": 10,
     * ]);
     * ```
     *
     * Is equivalent to:
     *
     * ```
     * myquery
     * .select(["id", "name"])
     * .where(["created >=": "2013-01-01"])
     * .limit(10)
     * ```
     *
     * Custom options can be read via `getOptions()`:
     *
     * ```
     * myquery.applyOptions([
     * "fields": ["id", "name"],
     * "custom": "value",
     * ]);
     * ```
     *
     * Here `options` will hold `["custom": "value"]` (the `fields`
     * option will be applied to the query instead of being stored, as
     * it"s a query clause related option):
     *
     * ```
     * options = myquery.getOptions();
     * ```
     */
    void applyOptions(Json[string] optionsToApply) {
        myvalid = [
            "select": "select",
            "fields": "select",
            "conditions": "where",
            "where": "where",
            "join": "join",
            "order": "orderBy",
            "orderBy": "orderBy",
            "limit": "limit",
            "offset": "offset",
            "group": "groupBy",
            "groupBy": "groupBy",
            "having": "having",
            "contain": "contain",
            "page": "page",
        ];

        ksort(optionsToApply);
        foreach (myoption, myvalues; optionsToApply) {
            if (isSet(myvalid[myoption], myvalues)) {
                this.{myvalid[myoption]}(myvalues);
            } else {
               _options[myoption] = myvalues;
            }
        }
    }
    
    // Decorates the results iterator with MapReduce routines and formatters
    protected IResultset _decorateResults(Json[string] result) {
        auto mydecorator = _decoratorClass();

        auto result;
        if (!_mapReduce.isEmpty) {
            _mapReduce.each!(functions => result = new DMapReduce(result, functions["mapper"], functions["reducer"]));
            result = new mydecorator(result);
        }
        if (!(cast(IResultset)result)) {
            result = new mydecorator(result);
        }
        if (!_formatters.isEmpty) {
            _formatters.each!(formatter => result = formatter(result, this));
            if (!(cast(IResultset)result)) {
                result = new mydecorator(result);
            }
        }
        return result;
    }
    
    /**
     * Returns the name of the class to be used for decorating results
     */
    protected string _decoratorClass() {
        return ResultsetDecorator.classname;
    }
    
    /**
     * Adds new fields to be returned by a `SELECT` statement when this query is
     * executed. Fields can be passed as an array of strings, Json[string] of expression
     * objects, a single expression or a single string.
     *
     * If an array is passed, keys will be used to alias fields using the value as the
     * real field to be aliased. It is possible to alias strings, Expression objects or
     * even other Query objects.
     *
     * If a callback is passed, the returning array of the auto will
     * be used as the list of fields.
     *
     * By default this auto will append any passed argument to the list of fields
     * to be selected, unless the second argument is set to true.
     *
     * ### Examples:
     *
     * ```
     * myquery.select(["id", "title"]); // Produces SELECT id, title
     * myquery.select(["author": "author_id"]); // Appends author: SELECT id, title, author_id as author
     * myquery.select("id", true); // Resets the list: SELECT id
     * myquery.select(["total": mycountQuery]); // SELECT id, (SELECT ...) AS total
     * myquery.select(function (myquery) {
     *   return ["article_id", "total": myquery.count("*")];
     * })
     * ```
     *
     * By default no fields are selected, if you have an instance of `UIM\ORM\Query` and try to append
     * fields you should also call `UIM\ORM\Query.enableAutoFields()` to select the default fields
     * from the table.
     *
     * If you pass an instance of a `UIM\ORM\Table` or `UIM\ORM\Association` class,
     * all the fields in the schema of the table or the association will be added to
     * the select clause.
     * Params:
     * \UIM\Database\IExpression|\ORM\Table|\ORM\Association|\/* Closure * / string[] fieldNames Fields
     * to be added to the list.
     * @param bool shouldOverwrite whether to reset fields with passed list or not
     */
    auto select(
        IExpression|Table|Association|/* Closure */ string[] fieldNames = [],
        bool shouldOverwrite = false
   ) {
        if (cast(DAssociation)fieldNames) {
            fieldNames = fieldNames.getTarget();
        }
        if (cast(Table)fieldNames) {
            if (_aliasingEnabled) {
                fieldNames = this.aliasFields(fieldNames.getSchema().columns(), fieldNames.aliasName());
            } else {
                fieldNames = fieldNames.getSchema().columns();
            }
        }
        return super.select(fieldNames, shouldOverwrite);
    }
    
    /**
     * Behaves the exact same as `select()` except adds the field to the list of fields selected and
     * does not disable auto-selecting fields for Associations.
     *
     * Use this instead of calling `select()` then `enableAutoFields()` to re-enable auto-fields.
     * Params:
     * \UIM\Database\IExpression|\ORM\Table|\ORM\Association|\/* Closure */ string[] fieldNames Fields
     * to be added to the list.
     */
    auto selectAlso(
        IExpression|Table|Association|/* Closure */ string[] fieldNames
   ) {
        this.select(fieldNames);
       _autoFields = true;

        return this;
    }
    
    /**
     * All the fields associated with the passed table except the excluded
     * fields will be added to the select clause of the query. Passed excluded fields should not be aliased.
     * After the first call to this method, a second call cannot be used to remove fields that have already
     * been added to the query by the first. If you need to change the list after the first call,
     * pass overwrite boolean true which will reset the select clause removing all previous additions.
     */
    auto selectAllExcept(/* Table| */Association mytable, Json[string] myexcludedFields, bool shouldOverwrite = false) {
        return selectAllExcept(mytable.getTarget(), myexcludedFields, shouldOverwrite);
    }
    auto selectAllExcept(DORMTable mytable, Json[string] myexcludedFields, bool shouldOverwrite = false) {
        fieldNames = array_diff(mytable.getSchema().columns(), myexcludedFields);
        if (_aliasingEnabled) {
            fieldNames = this.aliasFields(fieldNames);
        }
        return _select(fieldNames, shouldOverwrite);
    }
    
    /**
     * Sets the instance of the eager loader class to use for loading associations
     * and storing containments.
     * Params:
     * \ORM\EagerLoader myinstance The eager loader to use.
     */
    void setEagerLoader(EagerLoader myinstance) {
       _eagerLoader = myinstance;
    }
    
    // Returns the currently configured instance.
    EagerLoader getEagerLoader() {
        return _eagerLoader ??= new DEagerLoader();
    }
    
    /**
     * Sets the list of associations that should be eagerly loaded along with this
     * query. The list of associated tables passed must have been previously set as
     * associations using the Table API.
     *
     * ### Example:
     *
     * ```
     * Bring articles" author information
     * myquery.contain("Author");
     *
     * Also bring the category and tags associated to each article
     * myquery.contain(["Category", "Tag"]);
     * ```
     *
     * Associations can be arbitrarily nested using dot notation or nested arrays,
     * this allows this object to calculate joins or any additional queries that
     * must be executed to bring the required associated data.
     *
     * ### Example:
     *
     * ```
     * Eager load the product info, and for each product load other 2 associations
     * myquery.contain(["Product": ["Manufacturer", "Distributor"]);
     *
     * Which is equivalent to calling
     * myquery.contain(["Products.Manufactures", "Products.Distributors"]);
     *
     * For an author query, load his region, state and country
     * myquery.contain("Regions.States.Countries");
     * ```
     *
     * It is possible to control the conditions and fields selected for each of the
     * contained associations:
     *
     * ### Example:
     *
     * ```
     * myquery.contain(["Tags": auto (myq) {
     *   return myq.where(["Tags.is_popular": true.toJson]);
     * }]);
     *
     * myquery.contain(["Products.Manufactures": auto (myq) {
     *   return myq.select(["name"]).where(["Manufactures.active": true.toJson]);
     * }]);
     * ```
     *
     * Each association might define special options when eager loaded, the allowed
     * options that can be set per association are:
     *
     * - `foreignKeys`: Used to set a different field to match both tables, if set to false
     * no join conditions will be generated automatically. `false` can only be used on
     * joinable associations and cannot be used with hasMany or belongsToMany associations.
     * - `fields`: An array with the fields that should be fetched from the association.
     * - `finder`: The finder to use when loading associated records. Either the name of the
     * finder as a string, or an array to define options to pass to the finder.
     * - `queryBuilder`: Equivalent to passing a callback instead of an options array.
     *
     * ### Example:
     *
     * ```
     * Set options for the hasMany articles that will be eagerly loaded for an author
     * myquery.contain([
     *   "Articles": [
     *       "fields": ["title", "author_id"]
     *   ]
     * ]);
     * ```
     *
     * Finders can be configured to use options.
     *
     * ```
     * Retrieve translations for the articles, but only those for the `en` and `es` locales
     * myquery.contain([
     *   "Articles": [
     *       "finder": [
     *           "translations": [
     *               "locales": ["en", "es"]
     *           ]
     *       ]
     *   ]
     * ]);
     * ```
     *
     * When containing associations, it is important to include foreign key columns.
     * Failing to do so will trigger exceptions.
     *
     * ```
     * Use a query builder to add conditions to the containment
     * myquery.contain("Authors", auto (myq) {
     *   return myq.where(...); // add conditions
     * });
     * Use special join conditions for multiple containments in the same method call
     * myquery.contain([
     *   "Authors": [
     *       "foreignKeys": false.toJson,
     *       "queryBuilder": auto (myq) {
     *           return myq.where(...); // Add full filtering conditions
     *       }
     *   ],
     *   "Tags": auto (myq) {
     *       return myq.where(...); // add conditions
     *   }
     * ]);
     * ```
     *
     * If called with an empty first argument and `shouldOverride` is set to true, the
     * previous list will be emptied.
     */
    auto contain(string[] associations, /* IClosure| */bool shouldOverride = false) {
        auto loader = getEagerLoader();
        if (shouldOverride == true) {
            clearContain();
        }
        
        auto queryBuilder = null;
/*        if (cast(DClosure)shouldOverride) {
            queryBuilder = shouldOverride;
        } */
        if (associations) {
            myloader.contain(associations, myqueryBuilder);
        }
       _addAssociationsToTypeMap(
            getRepository(),
            getTypeMap(),
            myloader.getContain()
       );

        return this;
    }
    
    array getContain() {
        return _getEagerLoader().getContain();
    }
    
    // Clears the contained associations from the current query.
    auto clearContain() {
        getEagerLoader().clearContain();
       _isChanged();

        return this;
    }
    
    // Used to recursively add contained association column types to the query.
    protected void _addAssociationsToTypeMap(DORMTable mytable, TypeMap mytypeMap, Json[string] associations) {
        foreach (myname, mynested; associations) {
            if (!mytable.hasAssociation(myname)) {
                continue;
            }
            auto myassociation = mytable.getAssociation(myname);
            auto mytarget = myassociation.getTarget();
            auto primaryKeys = mytarget.primaryKeys();
            if (isEmpty(primaryKeys) || mytypeMap.type(mytarget.aliasField(primaryKeys[0])).isNull) {
                this.addDefaultTypes(mytarget);
            }
            if (!mynested.isEmpty) {
               _addAssociationsToTypeMap(mytarget, mytypeMap, mynested);
            }
        }
    }
    
    /**
     * Adds filtering conditions to this query to only bring rows that have a relation
     * to another from an associated table, based on conditions in the associated table.
     *
     * This auto will add entries in the `contain` graph.
     *
     * ### Example:
     *
     * ```
     * Bring only articles that were tagged with "uim"
     * myquery.matching("Tags", auto (myq) {
     *   return myq.where(["name": "uim"]);
     * });
     * ```
     *
     * It is possible to filter by deep associations by using dot notation:
     *
     * ### Example:
     *
     * ```
     * Bring only articles that were commented by "markstory"
     * myquery.matching("Comments.Users", auto (myq) {
     *   return myq.where(["username": "markstory"]);
     * });
     * ```
     *
     * As this auto will create `INNER JOIN`, you might want to consider
     * calling `distinct` on this query as you might get duplicate rows if
     * your conditions don"t filter them already. This might be the case, for example,
     * of the same user commenting more than once in the same article.
     *
     * ### Example:
     *
     * ```
     * Bring unique articles that were commented by "markstory"
     * myquery.distinct(["Articles.id"])
     *   .matching("Comments.Users", auto (myq) {
     *       return myq.where(["username": "markstory"]);
     *   });
     * ```
     *
     * Please note that the query passed to the closure will only accept calling
     * `select`, `where`, `andWhere` and `orWhere` on it. If you wish to
     * add more complex clauses you can do it directly in the main query.
     */
    void matching(string association, DClosure mybuilder = null) {
        result = getEagerLoader().setMatching(association, mybuilder).getMatching();
       _addAssociationsToTypeMap(getRepository(), getTypeMap(), result);
       _isChanged();
    }
    
    /**
     * Creates a LEFT JOIN with the passed association table while preserving
     * the foreign key matching and the custom conditions that were originally set
     * for it.
     *
     * This auto will add entries in the `contain` graph.
     *
     * ### Example:
     *
     * ```
     * Get the count of articles per user
     * myusersQuery
     *   .select(["total_articles": myquery.func().count("Articles.id")])
     *   .leftJoinWith("Articles")
     *   .groupBy(["Users.id"])
     *   .enableAutoFields();
     * ```
     *
     * You can also customize the conditions passed to the LEFT JOIN:
     *
     * ```
     * Get the count of articles per user with at least 5 votes
     * myusersQuery
     *   .select(["total_articles": myquery.func().count("Articles.id")])
     *   .leftJoinWith("Articles", auto (myq) {
     *       return myq.where(["Articles.votes >=": 5]);
     *   })
     *   .groupBy(["Users.id"])
     *   .enableAutoFields();
     * ```
     *
     * This will create the following SQL:
     *
     * ```
     * SELECT COUNT(Articles.id) AS total_articles, Users.*
     * FROM users Users
     * LEFT JOIN articles Articles ON Articles.user_id = Users.id AND Articles.votes >= 5
     * GROUP BY USers.id
     * ```
     *
     * It is possible to left join deep associations by using dot notation
     *
     * ### Example:
     *
     * ```
     * Total comments in articles by "markstory"
     * myquery
     *   .select(["total_comments": myquery.func().count("Comments.id")])
     *   .leftJoinWith("Comments.Users", auto (myq) {
     *       return myq.where(["username": "markstory"]);
     *   })
     *  .groupBy(["Users.id"]);
     * ```
     *
     * Please note that the query passed to the closure will only accept calling
     * `select`, `where`, `andWhere` and `orWhere` on it. If you wish to
     * add more complex clauses you can do it directly in the main query.
     */
    void leftJoinWith(string associationToJoin/* , DClosure mybuilder = null */) {
        result = getEagerLoader()
            .setMatching(associationToJoin, null /* mybuilder */, [
                "joinType": JOIN_TYPE_LEFT,
                "fields": false.toJson,
            ])
            .getMatching();
       _addAssociationsToTypeMap(getRepository(), getTypeMap(), result);
       _isChanged();
    }
    
    /**
     * Creates an INNER JOIN with the passed association table while preserving
     * the foreign key matching and the custom conditions that were originally set
     * for it.
     *
     * This auto will add entries in the `contain` graph.
     *
     * ### Example:
     *
     * ```
     * Bring only articles that were tagged with "uim"
     * myquery.innerJoinWith("Tags", auto (myq) {
     *   return myq.where(["name": "uim"]);
     * });
     * ```
     *
     * This will create the following SQL:
     *
     * ```
     * SELECT Articles.*
     * FROM articles Articles
     * INNER JOIN tags Tags ON Tags.name = "uim"
     * INNER JOIN articles_tags ArticlesTags ON ArticlesTags.tag_id = Tags.id
     * AND ArticlesTags.articles_id = Articles.id
     * ```
     *
     * This auto works the same as `matching()` with the difference that it
     * will select no fields from the association.
     */
    void innerJoinWith(string associationToJoin/* , Closure mybuilder = null */) {
        result = getEagerLoader()
            .setMatching(associationToJoin, null /* mybuilder */, [
                "joinType": JOIN_TYPE_INNER,
                "fields": false.toJson,
            ])
            .getMatching();
       _addAssociationsToTypeMap(getRepository(), getTypeMap(), result);
       _isChanged();
    }
    
    /**
     * Adds filtering conditions to this query to only bring rows that have no match
     * to another from an associated table, based on conditions in the associated table.
     *
     * This auto will add entries in the `contain` graph.
     *
     * ### Example:
     *
     * ```
     * Bring only articles that were not tagged with "uim"
     * myquery.notMatching("Tags", auto (myq) {
     *   return myq.where(["name": "uim"]);
     * });
     * ```
     *
     * It is possible to filter by deep associations by using dot notation:
     *
     * ### Example:
     *
     * ```
     * Bring only articles that weren"t commented by "markstory"
     * myquery.notMatching("Comments.Users", auto (myq) {
     *   return myq.where(["username": "markstory"]);
     * });
     * ```
     *
     * As this auto will create a `LEFT JOIN`, you might want to consider
     * calling `distinct` on this query as you might get duplicate rows if
     * your conditions don"t filter them already. This might be the case, for example,
     * of the same article having multiple comments.
     *
     * ### Example:
     *
     * ```
     * Bring unique articles that were commented by "markstory"
     * myquery.distinct(["Articles.id"])
     *   .notMatching("Comments.Users", auto (myq) {
     *       return myq.where(["username": "markstory"]);
     *   });
     * ```
     *
     * Please note that the query passed to the closure will only accept calling
     * `select`, `where`, `andWhere` and `orWhere` on it. If you wish to
     * add more complex clauses you can do it directly in the main query.
     * Params:
     * string association The association to filter by
     * @param \Closure|null mybuilder a auto that will receive a pre-made query object
     * that can be used to add custom conditions or selecting some fields
     */
    void notMatching(string association, Closure mybuilder = null) {
        result = getEagerLoader()
            .setMatching(association, mybuilder, [
                "joinType": JOIN_TYPE_LEFT,
                "fields": false.toJson,
                "negateMatch": true.toJson,
            ])
            .getMatching();
       _addAssociationsToTypeMap(getRepository(), getTypeMap(), result);
       _isChanged();
    }
    
    /**
     * Creates a copy of this current query, triggers beforeFind and resets some state.
     *
     * The following state will be cleared:
     *
     * - autoFields
     * - limit
     * - offset
     * - map/reduce functions
     * - result formatters
     * - order
     * - containments
     *
     * This method creates query clones that are useful when working with subqueries.
     */
    static cleanCopy() {
        myclone = this.clone;
        myclone.triggerBeforeFind();
        myclone.disableAutoFields();
        myclone.limit(null);
        myclone.orderBy([], true);
        myclone.offset(null);
        myclone.mapReduce(null, null, true);
        myclone.formatResults(null, OVERWRITE);
        myclone.setSelectTypeMap(new DTypeMap());
        myclone.decorateResults(null, true);

        return myclone;
    }
    
    /**
     * Clears the internal result cache and the internal count value from the current
     * query object.
     */
    void clearResult() {
       _isChanged();
    }
    
    // Handles cloning eager loaders.
    auto clone() {
        super.clone();
        if (_eagerLoader !is null) {
           _eagerLoader = _eagerLoader.clone;
        }
    }
    
    /**

     * Returns the COUNT(*) for the query. If the query has not been
     * modified, and the count has already been performed the cached
     * value is returned
     */
    size_t count() {
        return _resultsCount ? _resultsCount : _performCount();
    }
    
    // Performs and returns the COUNT(*) for the query.
    protected int _performCount() {
        auto myquery = this.cleanCopy();
        auto mycounter = _counter;
        if (mycounter !is null) {
            myquery.counter(null);

            return to!int(mycounter(myquery));
        }
        auto mycomplex = (
            myquery.clause("distinct") ||
            count(myquery.clause("group")) ||
            count(myquery.clause("union")) ||
            myquery.clause("having")
       );

        if (!mycomplex) {
            // Expression fields could have bound parameters.
            foreach (fieldName; myquery.clause("select")) {
                if (cast(IExpression)fieldName) {
                    mycomplex = true;
                    break;
                }
            }
        }
        if (!mycomplex && _valueBinder !is null) {
            myorder = this.clause("order");
            assert(myorder.isNull || cast(QueryExpression)myorder);
            mycomplex = myorder.isNull ? false : myorder.hasNestedExpression();
        }
        mycount = ["count": myquery.func().count("*")];

        if (!mycomplex) {
            myquery.getEagerLoader().disableAutoFields();
            mystatement = myquery
                .select(mycount, true)
                .disableAutoFields()
                .execute();
        } else {
            mystatement = getConnection().selectQuery()
                .select(mycount)
                .from(["count_source": myquery])
                .execute();
        }
        result = mystatement.fetch("assoc");

        if (result == false) {
            return 0;
        }
        return to!int(result["count"]);
    }
    
    /**
     * Registers a callback that will be executed when the `count` method in
     * this query is called. The return value for the auto will be set as the
     * return value of the `count` method.
     *
     * This is particularly useful when you need to optimize a query for returning the
     * count, for example removing unnecessary joins, removing group by or just return
     * an estimated number of rows.
     *
     * The callback will receive as first argument a clone of this query and not this
     * query it
     *
     * If the first param is a null value, the built-in counter auto will be called
     * instead
     * Params:
     * \Closure|null mycounter The counter value
     */
    auto counter(Closure mycounter) {
       _counter = mycounter;

        return this;
    }
    
    /**
     * Toggle hydrating entities.
     *
     * If set to false array results will be returned for the query.
     * Params:
     * bool myenable Use a boolean to set the hydration mode.
     */
    auto enableHydration(bool myenable = true) {
       _isChanged();
       _hydrate = myenable;

        return this;
    }
    
    /**
     * Disable hydrating entities.
     *
     * Disabling hydration will cause array results to be returned for the query
     * instead of entities.
     */
    auto disableHydration() {
       _isChanged();
       _hydrate = false;

        return this;
    }
    
    // Returns the current hydration mode.
    bool isHydrationEnabled() {
        return _hydrate;
    }
    
    /**
     * Trigger the beforeFind event on the query"s repository object.
     *
     * Will not trigger more than once, and only for select queries.
     */
    void triggerBeforeFind() {
        if (!_beforeFindFired) {
           _beforeFindFired = true;

            myrepository = getRepository();
            myrepository.dispatchEvent("Model.beforeFind", [
                this,
                new Json[string](_options),
                !this.isEagerLoaded(),
            ]);
        }
    }
 
    string sql(DValueBinder mybinder = null) {
        this.triggerBeforeFind();

       _transformQuery();

        return super.sql(mybinder);
    }
    
    /**
     * Executes this query and returns an range containing the results.
     */
    protected Json[string] _execute() {
        this.triggerBeforeFind();
        if (_results) {
            return _results;
        }
        results = super.all();
        if (!results.isArray) {
            results = iterator_to_array(results);
        }
        results = getEagerLoader().loadExternal(this, results);

        return _resultSetFactory().createResultset(this, results);
    }
    
    /**
     * Get resultset factory.
     */
    protected DResultsetFactory resultSetFactory() {
        return _resultSetFactory ??= new DResultsetFactory();
    }
    
    /**
     * Applies some defaults to the query object before it is executed.
     *
     * Specifically add the FROM clause, adds default table fields if none are
     * specified and applies the joins required to eager load associations defined
     * using `contain`
     *
     * It also sets the default types for the columns in the select clause
     */
    protected void _transformQuery() {
        if (!_isDirty) {
            return;
        }

        auto myrepository = getRepository();
        if (_parts.isEmpty("from")) {
            this.from([myrepository.aliasName(): myrepository.getTable()]);
        }
       _addDefaultFields();
        getEagerLoader().attachAssociations(this, myrepository, !_hasFields);
       _addDefaultSelectTypes();
    }
    
    /**
     * Inspects if there are any set fields for selecting, otherwise adds all
     * the fields for the default table.
     */
    protected void _addDefaultFields() {
        auto myselect = this.clause("select");
       _hasFields = true;

        myrepository = getRepository();

        if (!count(myselect) || _autoFields == true) {
           _hasFields = false;
            this.select(myrepository.getSchema().columns());
            myselect = this.clause("select");
        }
        if (_aliasingEnabled) {
            myselect = this.aliasFields(myselect, myrepository.aliasName());
        }
        this.select(myselect, true);
    }
    
    // Sets the default types for converting the fields in the select clause
    protected void _addDefaultSelectTypes() {
        auto mytypeMap = getTypeMap().getDefaults();
        auto myselect = this.clause("select");
        auto mytypes = null;

        foreach (aliasName: myvalue; myselect) {
            if (cast(ITypedResult)myvalue) {
                mytypes[aliasName] = myvalue.getReturnType();
                continue;
            }
            if (isSet(mytypeMap[aliasName])) {
                mytypes[aliasName] = mytypeMap[aliasName];
                continue;
            }
            if (isString(myvalue) && mytypeMap.hasKey(myvalue)) {
                mytypes[aliasName] = mytypeMap[myvalue];
            }
        }
        getSelectTypeMap().addDefaults(mytypes);
    }
    
    /**
 Params:
     * string myfinder The finder method to use.
     * @param Json ...myargs Arguments that match up to finder-specific parameters
     */
    static find(string myfinder, Json ...myargs) {
        mytable = getRepository();

        /** @psalm-suppress LessSpecificReturnStatement */
        return mytable.callFinder(myfinder, this, ...myargs);
    }
    
    /**
     * Disable auto adding table"s alias to the fields of SELECT clause.
     */
    auto disableAutoAliasing() {
        _aliasingEnabled = false;

        return this;
    }
    
    /**
     * Marks a query as dirty, removing any preprocessed information
     * from in memory caching such as previous results
     */
    protected void _isChanged() {
       _results = null;
       _resultsCount = null;
        super._isChanged();
    }
 
    Json[string] debugInfo() {
        myeagerLoader = getEagerLoader();

        return super.__debugInfo() ~ [
            "hydrate": _hydrate,
            "formatters": count(_formatters),
            "mapReducers": count(_mapReduce),
            "contain": myeagerLoader.getContain(),
            "matching": myeagerLoader.getMatching(),
            "extraOptions": _options,
            "repository": _repository,
        ];
    }
    
    /**
     * Executes the query and converts the result set into Json.
     *
     * Part of JsonSerializable interface.
     */
    IResultset<(\UIM\Datasource\IORMEntity|mixed)> JsonSerialize() {
        return _all();
    }
    
    /**
     * Sets whether the ORM should automatically append fields.
     *
     * By default calling select() will disable auto-fields. You can re-enable
     * auto-fields with this method.
     * Params:
     * bool myvalue Set true to enable, false to disable.
     */
    auto enableAutoFields(bool myvalue = true) {
       _autoFields = myvalue;

        return this;
    }
    
    /**
     * Disables automatically appending fields.
     */
    auto disableAutoFields() {
       _autoFields = false;

        return this;
    }
    
    /**
     * Gets whether the ORM should automatically append fields.
     *
     * By default calling select() will disable auto-fields. You can re-enable
     * auto-fields with enableAutoFields().
     */
    bool isAutoFieldsEnabled() {
        return _autoFields;
    }
}
