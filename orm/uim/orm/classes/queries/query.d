module uim.orm.classes.queries.query;

import uim.orm;

@safe:
    
/**
 * : the base Query class to provide new methods related to association
 * loading, automatic fields selection, automatic type casting and to wrap results
 * into a specific iterator that will be responsible for hydrating results if
 * required.
 *
 * @property DORMTable _repository Instance of a table object this query is bound to.
 * @method DORMTable getRepository() Returns the default table object that will be used by this query,
 *   that is, the table that will appear in the from clause.
 * @method DORMcollections.ICollection each(callable c) Passes each of the query results to the callable
 * @method DORMcollections.ICollection sortBy(callable|string path, int order = \SORT_DESC, int sort = \SORT_NUMERIC) Sorts the query with the callback
 * @method DORMcollections.ICollection filter(callable c = null) Keeps the results using passing the callable test
 * @method DORMcollections.ICollection reject(callable c) Removes the results passing the callable test
 * @method bool every(callable c) Returns true if all the results pass the callable test
 * @method bool any(callable c) Returns true if at least one of the results pass the callable test
 * @method DORMcollections.ICollection map(callable c) Modifies each of the results using the callable
 * @method mixed reduce(callable c, zero = null) Folds all the results into a single value using the callable.
 * @method DORMcollections.ICollection extract(field) Extracts a single column from each row
 * @method mixed max(field) Returns the maximum value for a single column in all the results.
 * @method mixed min(field) Returns the minimum value for a single column in all the results.
 * @method DORMcollections.ICollection groupBy(callable|string field) In-memory group all results by the value of a column.
 * @method DORMcollections.ICollection indexBy(callable|string callback) Returns the results indexed by the value of a column.
 * @method DORMcollections.ICollection countBy(callable|string field) Returns the number of unique values for a column
 * @method float sumOf(callable|string field) Returns the sum of all values for a single column
 * @method DORMcollections.ICollection shuffle() In-memory randomize the order the results are returned
 * @method DORMcollections.ICollection sample(int size = 10) In-memory shuffle the results and return a subset of them.
 * @method DORMcollections.ICollection take(int size = 1, int from = 0) In-memory limit and offset for the query results.
 * @method DORMcollections.ICollection skip(int howMany) Skips some rows from the start of the query result.
 * @method mixed last() Return the last row of the query result
 * @method DORMcollections.ICollection append(array|\Traversable items) Appends more rows to the result of the query.
 * @method DORMcollections.ICollection combine(k, v, g = null) Returns the values of the column v index by column k,
 *   and grouped by g.
 * @method DORMcollections.ICollection nest(k, p, n = "children") Creates a tree structure by nesting the values of column p into that
 *   with the same value for k using n as the nesting key.
 * @method Json[string] toDataArray() Returns a key-value array with the results of this query.
 * @method array toList() Returns a numerically indexed array with the results of this query.
 * @method DORMcollections.ICollection stopWhen(callable c) Returns each row until the callable returns true.
 * @method DORMcollections.ICollection zip(array|\Traversable c) Returns the first result of both the query and c in an array,
 *   then the second results and so on.
 * @method DORMcollections.ICollection zipWith(collections, callable callable) Returns each of the results out of calling c
 *   with the first rows of the query and each of the items, then the second rows and so on.
 * @method DORMcollections.ICollection chunk(int size) Groups the results in arrays of size rows each.
 * @method bool isEmpty() Returns true if this query found no results.
 */
class DQuery : IQuery { // DatabaseQuery : JsonSerializable, IQuery
/*
    use TQuery() {
        cache as private _cache;
        all as private _all;
        _decorateResults as private _applyDecorators;
        __call as private _call;
    }

    /**
     * Set the default Table object that will be used by this query
     * and form the `FROM` clause.
     *
     * @param \uim\Datasource\IRepository|\uim\ORM\Table myRepository The default table object to use
     */
    IQuery repository(IRepository myRepository) {
      _repository = myRepository;

      return this;
    }

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
    protected bool _hasFields;

    /**
     * Tracks whether the original query should include
     * fields from the top level table.
     */
    protected bool _autoFields;

    // Whether to hydrate results into entity objects
    protected bool _hydrate = true;

    // Whether aliases are generated for fields.
    protected bool _aliasingEnabled = true;

    /**
     * A callable function that can be used to calculate the total amount of
     * records this query will match when not using `limit`
     *
     * @var callable|null
     */
    // protected _counter;

    /**
     * Instance of a class responsible for storing association containments and
     * for eager loading them when this query is executed
     */
    protected DORMEagerLoader _eagerLoader;

    // True if the beforeFind event has already been triggered for this query
    protected bool _beforeFindFired = false;

    /**
     * The COUNT(*) for the query.
     *
     * When set, count query execution will be bypassed.
     */
    protected int _resultsCount;

    /**
     
     *
     * @param DORMdatabases.Connection connection The connection object
     * @param DORMDORMTable aTable The table this query is starting on
     */
    this(IConnection aConnection, DORMTable aTable) {
        super(aConnection);
        this.repository(aTable);

        if (_repository != null) {
            this.addDefaultTypes(_repository);
        }
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
     * If a callable bool is passed, the returning array of the function will
     * be used as the list of fields.
     *
     * By default this function will append any passed argument to the list of fields
     * to be selected, unless the second argument is set to true.
     *
     * ### Examples:
     *
     * ```
     * query.select(["id", "title"]); // Produces SELECT id, title
     * query.select(["author": "author_id"]); // Appends author: SELECT id, title, author_id as author
     * query.select("id", true); // Resets the list: SELECT id
     * query.select(["total": countQuery]); // SELECT id, (SELECT ...) AS total
     * query.select(function (query) {
     *     return ["article_id", "total": query.count("*")];
     * })
     * ```
     *
     * By default no fields are selected, if you have an instance of `uim\orm.Query` and try to append
     * fields you should also call `uim\orm.Query.enableAutoFields()` to select the default fields
     * from the table.
     *
     * If you pass an instance of a `uim\orm.Table` or `uim\orm.Association` class,
     * all the fields in the schema of the table or the association will be added to
     * the select clause.
     *
     * @param DORMdatabases.IExpression|DORMTable|DORMAssociation|callable|array|string fields Fields
     * to be added to the list.
     * @param bool canOverwrite whether to reset fields with passed list or not
     * @return this
     */
     
    IQuery select(IExpression anExpression, bool canOverwrite = false) {
    }

    IQuery select(DORMTable anTable, bool canOverwrite = false) {
      string[] fieldNames; 

      if (this.aliasingEnabled) {
          fields = this.aliasFields(anTable.getSchema().columns(), anTable.aliasName());
      } else {
          fields = anTable.getSchema().columns();
      }
      return fields(fields, canOverwrite);
    }

    IQuery select(DORMAssociation anAssociation, bool canOverwrite = false) {
      string[] fieldNames = anAssociation.getTarget();
    }

    IQuery select(string[] fieldNames, bool canOverwrite = false) {
      return super.select(fields, canOverwrite);
    }

    /**
     * All the fields associated with the passed table except the excluded
     * fields will be added to the select clause of the query. Passed excluded fields should not be aliased.
     * After the first call to this method, a second call cannot be used to remove fields that have already
     * been added to the query by the first. If you need to change the list after the first call,
     * pass overwrite boolean true which will reset the select clause removing all previous additions.
     *
     * @param DORMTable|DORMAssociation table The table to use to get an array of columns
     * @param string[] excludedFields The un-aliased column names you do not want selected from table
     * @param bool canOverwrite Whether to reset/remove previous selected fields
     * @return this
     * @throws \InvalidArgumentException If Association|Table is not passed in first argument
     */
    IQuery selectAllExcept(table, Json[string] excludedFields, bool canOverwrite = false) {
        if (cast(Association)table) {
            table = table.getTarget();
        }

        if (!(table instanceof Table)) {
            throw new DInvalidArgumentException("You must provide either an Association or a Table object");
        }

        fields = array_diff(table.getSchema().columns(), excludedFields);
        if (this.aliasingEnabled) {
            fields = this.aliasFields(fields);
        }

        return _select(fields, canOverwrite);
    }

    /**
     * Hints this object to associate the correct types when casting conditions
     * for the database. This is done by extracting the field types from the schema
     * associated to the passed table object. This prevents the user from repeating
     * themselves when specifying conditions.
     *
     * This method returns the same query object for chaining.
     *
     * @param DORMDORMTable aTable The table to pull types from
     */
    void addDefaultTypes(DORMTable aTable) {
        alias = table.aliasName();
        map = table.getSchema().typeMap();
        fields = null;
        foreach (map as f: type) {
            fields[f] = fields[alias ~ "." ~ f] = fields[alias ~ "__" ~ f] = type;
        }
        getTypeMap().addDefaults(fields);
    }

    /**
     * Returns the current configured query `_eagerLoaded` value
     */
    bool isEagerLoaded() {
      return _eagerLoaded;
    }
    /**
     * Sets the instance of the eager loader class to use for loading associations
     * and storing containments.
     *
     * @param DORMEagerLoader instance The eager loader to use.
     * @return this
     */
    function setEagerLoader(EagerLoader instance) {
        _eagerLoader = instance;

        return this;
    }

    // Returns the currently configured instance.
    DORMEagerLoader getEagerLoader() {
        if (_eagerLoader == null) {
          _eagerLoader = new DEagerLoader();
        }

        return _eagerLoader;
    }

    /**
     * Sets the list of associations that should be eagerly loaded along with this
     * query. The list of associated tables passed must have been previously set as
     * associations using the Table API.
     *
     * ### Example:
     *
     * ```
     * / Bring articles" author information
     * query.contain("Author");
     *
     * / Also bring the category and tags associated to each article
     * query.contain(["Category", "Tag"]);
     * ```
     *
     * Associations can be arbitrarily nested using dot notation or nested arrays,
     * this allows this object to calculate joins or any additional queries that
     * must be executed to bring the required associated data.
     *
     * ### Example:
     *
     * ```
     * / Eager load the product info, and for each product load other 2 associations
     * query.contain(["Product": ["Manufacturer", "Distributor"]);
     *
     * / Which is equivalent to calling
     * query.contain(["Products.Manufactures", "Products.Distributors"]);
     *
     * / For an author query, load his region, state and country
     * query.contain("Regions.States.Countries");
     * ```
     *
     * It is possible to control the conditions and fields selected for each of the
     * contained associations:
     *
     * ### Example:
     *
     * ```
     * query.contain(["Tags": function (q) {
     *     return q.where(["Tags.is_popular": true.toJson]);
     * }]);
     *
     * query.contain(["Products.Manufactures": function (q) {
     *     return q.select(["name"]).where(["Manufactures.active": true.toJson]);
     * }]);
     * ```
     *
     * Each association might define special options when eager loaded, the allowed
     * options that can be set per association are:
     *
     * - `foreignKey`: Used to set a different field to match both tables, if set to false
     *   no join conditions will be generated automatically. `false` can only be used on
     *   joinable associations and cannot be used with hasMany or belongsToMany associations.
     * - `fields`: An array with the fields that should be fetched from the association.
     * - `finder`: The finder to use when loading associated records. Either the name of the
     *   finder as a string, or an array to define options to pass to the finder.
     * - `queryBuilder`: Equivalent to passing a callable instead of an options array.
     *
     * ### Example:
     *
     * ```
     * / Set options for the hasMany articles that will be eagerly loaded for an author
     * query.contain([
     *     "Articles": [
     *         "fields": ["title", "author_id"]
     *     ]
     * ]);
     * ```
     *
     * Finders can be configured to use options.
     *
     * ```
     * / Retrieve translations for the articles, but only those for the `en` and `es` locales
     * query.contain([
     *     "Articles": [
     *         "finder": [
     *             "translations": [
     *                 "locales": ["en", "es"]
     *             ]
     *         ]
     *     ]
     * ]);
     * ```
     *
     * When containing associations, it is important to include foreign key columns.
     * Failing to do so will trigger exceptions.
     *
     * ```
     * / Use a query builder to add conditions to the containment
     * query.contain("Authors", function (q) {
     *     return q.where(...); // add conditions
     * });
     * / Use special join conditions for multiple containments in the same method call
     * query.contain([
     *     "Authors": [
     *         "foreignKey": false.toJson,
     *         "queryBuilder": function (q) {
     *             return q.where(...); // Add full filtering conditions
     *         }
     *     ],
     *     "Tags": function (q) {
     *         return q.where(...); // add conditions
     *     }
     * ]);
     * ```
     *
     * If called with an empty first argument and `override` is set to true, the
     * previous list will be emptied.
     *
     * @param array|string associations List of table aliases to be queried.
     * @param callable|bool override The query builder for the association, or
     *   if associations is an array, a bool on whether to override previous list
     *   with the one passed
     * defaults to merging previous list with the new one.
     */
    void contain(associations, override = false) {
        loader = getEagerLoader();
        if (override == true) {
            this.clearContain();
        }

        queryBuilder = null;
        if (is_callable(override)) {
            queryBuilder = override;
        }

        if (associations) {
            loader.contain(associations, queryBuilder);
        }
        _addAssociationsToTypeMap(
            getRepository(),
            getTypeMap(),
            loader.getContain()
        );
    }

    /**
     */
    Json[string] getContain() {
        return _getEagerLoader().getContain();
    }

    /**
     * Clears the contained associations from the current query.
     *
     * @return this
     */
    function clearContain() {
        getEagerLoader().clearContain();
        _isDirty();

        return this;
    }

    /**
     * Used to recursively add contained association column types to
     * the query.
     *
     * @param DORMDORMTable aTable The table instance to pluck associations from.
     * @param DORMdatabases.TypeMap typeMap The typemap to check for columns in.
     *   This typemap is indirectly mutated via {@link DORMQuery.addDefaultTypes()}
     * @param array<string, array> associations The nested tree of associations to walk.
     */
    protected void _addAssociationsToTypeMap(DORMTable aTable, TypeMap typeMap, Json[string] associations) {
        foreach (associations as name: nested) {
            if (!table.hasAssociation(name)) {
                continue;
            }
            association = table.getAssociation(name);
            target = association.getTarget();
            primary = (array)target.primaryKeys();
            if (primary.isEmpty || typeMap.type(target.aliasField(primary[0])) == null) {
                this.addDefaultTypes(target);
            }
            if (!nested.isEmpty) {
                _addAssociationsToTypeMap(target, typeMap, nested);
            }
        }
    }

    /**
     * Adds filtering conditions to this query to only bring rows that have a relation
     * to another from an associated table, based on conditions in the associated table.
     *
     * This function will add entries in the `contain` graph.
     *
     * ### Example:
     *
     * ```
     * / Bring only articles that were tagged with "uim"
     * query.matching("Tags", function (q) {
     *     return q.where(["name": "uim"]);
     * });
     * ```
     *
     * It is possible to filter by deep associations by using dot notation:
     *
     * ### Example:
     *
     * ```
     * / Bring only articles that were commented by "markstory"
     * query.matching("Comments.Users", function (q) {
     *     return q.where(["username": "markstory"]);
     * });
     * ```
     *
     * As this function will create `INNER JOIN`, you might want to consider
     * calling `distinct` on this query as you might get duplicate rows if
     * your conditions don"t filter them already. This might be the case, for example,
     * of the same user commenting more than once in the same article.
     *
     * ### Example:
     *
     * ```
     * / Bring unique articles that were commented by "markstory"
     * query.distinct(["Articles.id"])
     *     .matching("Comments.Users", function (q) {
     *         return q.where(["username": "markstory"]);
     *     });
     * ```
     *
     * Please note that the query passed to the closure will only accept calling
     * `select`, `where`, `andWhere` and `orWhere` on it. If you wish to
     * add more complex clauses you can do it directly in the main query.
     *
     * @param string assoc The association to filter by
     * @param callable|null builder a function that will receive a pre-made query object
     * that can be used to add custom conditions or selecting some fields
     * @return this
     */
    function matching(string assoc, ?callable builder = null) {
        result = getEagerLoader().setMatching(assoc, builder).getMatching();
        _addAssociationsToTypeMap(getRepository(), getTypeMap(), result);
        _isDirty();

        return this;
    }

    /**
     * Creates a LEFT JOIN with the passed association table while preserving
     * the foreign key matching and the custom conditions that were originally set
     * for it.
     *
     * This function will add entries in the `contain` graph.
     *
     * ### Example:
     *
     * ```
     * / Get the count of articles per user
     * usersQuery
     *     .select(["total_articles": query.func().count("Articles.id")])
     *     .leftJoinWith("Articles")
     *     .group(["Users.id"])
     *     .enableAutoFields();
     * ```
     *
     * You can also customize the conditions passed to the LEFT JOIN:
     *
     * ```
     * / Get the count of articles per user with at least 5 votes
     * usersQuery
     *     .select(["total_articles": query.func().count("Articles.id")])
     *     .leftJoinWith("Articles", function (q) {
     *         return q.where(["Articles.votes >=": 5]);
     *     })
     *     .group(["Users.id"])
     *     .enableAutoFields();
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
     * / Total comments in articles by "markstory"
     * query
     *     .select(["total_comments": query.func().count("Comments.id")])
     *     .leftJoinWith("Comments.Users", function (q) {
     *         return q.where(["username": "markstory"]);
     *     })
     *    .group(["Users.id"]);
     * ```
     *
     * Please note that the query passed to the closure will only accept calling
     * `select`, `where`, `andWhere` and `orWhere` on it. If you wish to
     * add more complex clauses you can do it directly in the main query.
     *
     * @param string assoc The association to join with
     * @param callable|null builder a function that will receive a pre-made query object
     * that can be used to add custom conditions or selecting some fields
     */
    void leftJoinWith(string assoc, ?callable builder = null) {
        result = getEagerLoader()
            .setMatching(assoc, builder, [
                "joinType": Query.JOIN_TYPE_LEFT,
                "fields": false.toJson,
            ])
            .getMatching();
        _addAssociationsToTypeMap(getRepository(), getTypeMap(), result);
        _isDirty();
    }

    /**
     * Creates an INNER JOIN with the passed association table while preserving
     * the foreign key matching and the custom conditions that were originally set
     * for it.
     *
     * This function will add entries in the `contain` graph.
     *
     * ### Example:
     *
     * ```
     * / Bring only articles that were tagged with "uim"
     * query.innerJoinWith("Tags", function (q) {
     *     return q.where(["name": "uim"]);
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
     *   AND ArticlesTags.articles_id = Articles.id
     * ```
     *
     * This function works the same as `matching()` with the difference that it
     * will select no fields from the association.
     *
     * @param string assoc The association to join with
     * @param callable|null builder a function that will receive a pre-made query object
     * that can be used to add custom conditions or selecting some fields
     */
    void innerJoinWith(string assoc, ?callable builder = null) {
        result = getEagerLoader()
            .setMatching(assoc, builder, [
                "joinType": Query.JOIN_TYPE_INNER,
                "fields": false.toJson,
            ])
            .getMatching();
        _addAssociationsToTypeMap(getRepository(), getTypeMap(), result);
        _isDirty();
    }

    /**
     * Adds filtering conditions to this query to only bring rows that have no match
     * to another from an associated table, based on conditions in the associated table.
     *
     * This function will add entries in the `contain` graph.
     *
     * ### Example:
     *
     * ```
     * / Bring only articles that were not tagged with "uim"
     * query.notMatching("Tags", function (q) {
     *     return q.where(["name": "uim"]);
     * });
     * ```
     *
     * It is possible to filter by deep associations by using dot notation:
     *
     * ### Example:
     *
     * ```
     * / Bring only articles that weren"t commented by "markstory"
     * query.notMatching("Comments.Users", function (q) {
     *     return q.where(["username": "markstory"]);
     * });
     * ```
     *
     * As this function will create a `LEFT JOIN`, you might want to consider
     * calling `distinct` on this query as you might get duplicate rows if
     * your conditions don"t filter them already. This might be the case, for example,
     * of the same article having multiple comments.
     *
     * ### Example:
     *
     * ```
     * / Bring unique articles that were commented by "markstory"
     * query.distinct(["Articles.id"])
     *     .notMatching("Comments.Users", function (q) {
     *         return q.where(["username": "markstory"]);
     *     });
     * ```
     *
     * Please note that the query passed to the closure will only accept calling
     * `select`, `where`, `andWhere` and `orWhere` on it. If you wish to
     * add more complex clauses you can do it directly in the main query.
     *
     * @param string assoc The association to filter by
     * @param callable|null builder a function that will receive a pre-made query object
     * that can be used to add custom conditions or selecting some fields
     * @return this
     */
    function notMatching(string assoc, ?callable builder = null) {
        result = getEagerLoader()
            .setMatching(assoc, builder, [
                "joinType": Query.JOIN_TYPE_LEFT,
                "fields": false.toJson,
                "negateMatch": true.toJson,
            ])
            .getMatching();
        _addAssociationsToTypeMap(getRepository(), getTypeMap(), result);
        _isDirty();

        return this;
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
     * query.applyOptions([
     *   "fields": ["id", "name"],
     *   "conditions": [
     *     "created >=": "2013-01-01"
     *   ],
     *   "limit": 10,
     * ]);
     * ```
     *
     * Is equivalent to:
     *
     * ```
     * query
     *   .select(["id", "name"])
     *   .where(["created >=": "2013-01-01"])
     *   .limit(10)
     * ```
     *
     * Custom options can be read via `getOptions()`:
     *
     * ```
     * query.applyOptions([
     *   "fields": ["id", "name"],
     *   "custom": "value",
     * ]);
     * ```
     *
     * Here `options` will hold `["custom": "value"]` (the `fields`
     * option will be applied to the query instead of being stored, as
     * it"s a query clause related option):
     *
     * ```
     * options = query.getOptions();
     * ```
     */
    void applyOptions(Json[string] optionData) {
        valid = [
            "fields": "select",
            "conditions": "where",
            "join": "join",
            "order": "order",
            "limit": "limit",
            "offset": "offset",
            "group": "group",
            "having": "having",
            "contain": "contain",
            "page": "page",
        ];

        ksort(options);
        foreach (options as option: values) {
            if (isset(valid[option], values)) {
                this.{valid[option]}(values);
            } else {
                _options[option] = values;
            }
        }
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
     *
     * @return static
     */
    function cleanCopy() {
        clone = clone this;
        clone.triggerBeforeFind();
        clone.disableAutoFields();
        clone.limit(null);
        clone.order([], true);
        clone.offset(null);
        clone.mapReduce(null, null, true);
        clone.formatResults(null, self.OVERWRITE);
        clone.setSelectTypeMap(new DTypeMap());
        clone.decorateResults(null, true);

        return clone;
    }

    /**
     * Clears the internal result cache and the internal count value from the current
     * query object.
     *
     * @return this
     */
    function clearResult() {
        _isDirty();

        return this;
    }

    /**
     * {@inheritDoc}
     *
     * Handles cloning eager loaders.
     */
    function clone() {
        super.clone();
        if (_eagerLoader != null) {
            _eagerLoader = clone _eagerLoader;
        }
    }

    /**
     * {@inheritDoc}
     *
     * Returns the COUNT(*) for the query. If the query has not been
     * modified, and the count has already been performed the cached
     * value is returned
     */
    size_t count() {
        if (_resultsCount == null) {
            _resultsCount = _performCount();
        }

        return _resultsCount;
    }

    /**
     * Performs and returns the COUNT(*) for the query.
     */
    protected int _performCount() {
        query = this.cleanCopy();
        counter = _counter;
        if (counter != null) {
            query.counter(null);

            return (int)counter(query);
        }

        complex = (
            query.clause("distinct") ||
            count(query.clause("group")) ||
            count(query.clause("union")) ||
            query.clause("having")
        );

        if (!complex) {
            // Expression fields could have bound parameters.
            foreach (query.clause("select") as field) {
                if (field instanceof IExpression) {
                    complex = true;
                    break;
                }
            }
        }

        if (!complex && _valueBinder != null) {
            order = this.clause("order");
            complex = order == null ? false : order.hasNestedExpression();
        }

        count = ["count": query.func().count("*")];

        if (!complex) {
            query.getEagerLoader().disableAutoFields();
            statement = query
                .select(count, true)
                .disableAutoFields()
                .execute();
        } else {
            statement = getConnection().newQuery()
                .select(count)
                .from(["count_source": query])
                .execute();
        }

        result = statement.fetch("assoc");
        statement.closeCursor();

        if (result == false) {
            return 0;
        }

        return (int)result["count"];
    }

    /**
     * Registers a callable function that will be executed when the `count` method in
     * this query is called. The return value for the function will be set as the
     * return value of the `count` method.
     *
     * This is particularly useful when you need to optimize a query for returning the
     * count, for example removing unnecessary joins, removing group by or just return
     * an estimated number of rows.
     *
     * The callback will receive as first argument a clone of this query and not this
     * query itself.
     *
     * If the first param is a null value, the built-in counter function will be called
     * instead
     *
     * @param callable|null counter The counter value
     */
    void counter(?callable counter) {
        _counter = counter;
    }

    /**
     * Toggle hydrating entities.
     *
     * If set to false array results will be returned for the query.
     *
     * @param bool enable Use a boolean to set the hydration mode.
     * @return this
     */
    function enableHydration(bool enable = true) {
        _isDirty();
        _hydrate = enable;

        return this;
    }

    /**
     * Disable hydrating entities.
     *
     * Disabling hydration will cause array results to be returned for the query
     * instead of entities.
     *
     * @return this
     */
    function disableHydration() {
        _isDirty();
        _hydrate = false;

        return this;
    }

    /**
     * Returns the current hydration mode.
     */
    bool isHydrationEnabled() {
        return _hydrate;
    }

    /**
     * {@inheritDoc}
     *
     * @param \Closure|string|false key Either the cache key or a function to generate the cache key.
     *   When using a function, this query instance will be supplied as an argument.
     * @param DORMCache\CacheEngine|string myConfiguration Either the name of the cache config to use, or
     *   a cache config instance.
     */
    auto cache(key, myConfiguration = "default") {
        if (_type != "select" && _type != null) {
            throw new DRuntimeException("You cannot cache the results of non-select queries.");
        }

        return _cache(key, myConfiguration);
    }

    /**
     * {@inheritDoc}
     *
     * @return DORMDatasource\IResultset
     * @throws \RuntimeException if this method is called on a non-select Query.
     */
    function all(): IResultset
    {
        if (_type != "select" && _type != null) {
            throw new DRuntimeException(
                "You cannot call all() on a non-select query. Use execute() instead."
            );
        }

        return _all();
    }

    /**
     * Trigger the beforeFind event on the query"s repository object.
     *
     * Will not trigger more than once, and only for select queries.
     */
    void triggerBeforeFind() {
        if (!_beforeFindFired && _type == "select") {
            _beforeFindFired = true;

            repository = getRepository();
            repository.dispatchEvent("Model.beforeFind", [
                this,
                new ArrayObject(_options),
                !this.isEagerLoaded(),
            ]);
        }
    }


    string sql(?DValueBinder aBinder = null) {
        this.triggerBeforeFind();

        _transformQuery();

        return super.sql(binder);
    }

    /**
     * Executes this query and returns a Resultset object containing the results.
     * This will also setup the correct statement class in order to eager load deep
     * associations.
     *
     * @return DORMDatasource\IResultset
     */
    protected function _execute(): IResultset
    {
        this.triggerBeforeFind();
        if (_results) {
            decorator = _decoratorClass();

            return new decorator(_results);
        }

        statement = getEagerLoader().loadExternal(this, this.execute());

        return new DResultset(this, statement);
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
        if (!_isDirty || _type != "select") {
            return;
        }

        repository = getRepository();

        if (_parts.isEmpty("from")) {
            this.from([repository.aliasName(): repository.getTable()]);
        }
        _addDefaultFields();
        getEagerLoader().attachAssociations(this, repository, !_hasFields);
        _addDefaultSelectTypes();
    }

    /**
     * Inspects if there are any set fields for selecting, otherwise adds all
     * the fields for the default table.
     */
    protected void _addDefaultFields() {
        select = this.clause("select");
        _hasFields = true;

        repository = getRepository();

        if (!count(select) || _autoFields == true) {
            _hasFields = false;
            this.select(repository.getSchema().columns());
            select = this.clause("select");
        }

        if (this.aliasingEnabled) {
            select = this.aliasFields(select, repository.aliasName());
        }
        this.select(select, true);
    }

    /**
     * Sets the default types for converting the fields in the select clause
     */
    protected void _addDefaultSelectTypes() {
        typeMap = getTypeMap().getDefaults();
        select = this.clause("select");
        types = null;

        foreach (select as alias: value) {
            if (value instanceof ITypedResult) {
                types[alias] = value.getReturnType();
                continue;
            }
            if (isset(typeMap[alias])) {
                types[alias] = typeMap[alias];
                continue;
            }
            if (value.isString && isset(typeMap[value])) {
                types[alias] = typeMap[value];
            }
        }
        getSelectTypeMap().addDefaults(types);
    }

    /**
     * {@inheritDoc}
     *
     * @param string finder The finder method to use.
     * @param Json[string] options The options for the finder.
     * @return static Returns a modified query.
     * @psalm-suppress MoreSpecificReturnType
     */
    function find(string finder, Json[string] optionData = null) {
        table = getRepository();

        /** @psalm-suppress LessSpecificReturnStatement */
        return table.callFinder(finder, this, options);
    }

    /**
     * Marks a query as dirty, removing any preprocessed information
     * from in memory caching such as previous results
     */
    protected void _isDirty() {
        _results = null;
        _resultsCount = null;
        super._isDirty();
    }

    /**
     * Create an update query.
     *
     * This changes the query type to be "update".
     * Can be combined with set() and where() methods to create update queries.
     *
     * @param DORMdatabases.IExpression|string|null table Unused parameter.
     * @return this
     */
    function update(table = null) {
        if (!table) {
            repository = getRepository();
            table = repository.getTable();
        }

        return super.update(table);
    }

    /**
     * Create a delete query.
     *
     * This changes the query type to be "delete".
     * Can be combined with the where() method to create delete queries.
     *
     * @param string|null table Unused parameter.
     * @return this
     */
    function remove(string table = null) {
        repository = getRepository();
        this.from([repository.aliasName(): repository.getTable()]);

        // We do not pass table to parent class here
        return super.remove();
    }

    /**
     * Create an insert query.
     *
     * This changes the query type to be "insert".
     * Note calling this method will reset any data previously set
     * with Query.values()
     *
     * Can be combined with the where() method to create delete queries.
     *
     * @param Json[string] columns The columns to insert into.
     * @param string[] types A map between columns & their datatypes.
     * @return this
     */
    function insert(Json[string] columns, Json[string] types = null) {
        repository = getRepository();
        table = repository.getTable();
        this.into(table);

        return super.insert(columns, types);
    }

    /**
     * Returns a new Query that has automatic field aliasing disabled.
     *
     * @param DORMDORMTable aTable The table this query is starting on
     * @return static
     */
    static function subquery(DORMTable aTable) {
        query = new static(table.getConnection(), table);
        query.aliasingEnabled = false;

        return query;
    }

    /**
     * {@inheritDoc}
     *
     * @param string method the method to call
     * @param Json[string] arguments list of arguments for the method to call
     * @return mixed
     * @throws \BadMethodCallException if the method is called for a non-select query
     */
    function __call(string method, Json[string] arguments) {
        if (this.type() == "select") {
            return _call(method, arguments);
        }

        throw new BadMethodCallException(
            sprintf("Cannot call method '%s' on a '%s' query", method, this.type())
        );
    }


    array __debugInfo() {
        eagerLoader = getEagerLoader();

        return super.__debugInfo() + [
            "hydrate": _hydrate,
            "buffered": _useBufferedResults,
            "formatters": count(_formatters),
            "mapReducers": count(_mapReduce),
            "contain": eagerLoader.getContain(),
            "matching": eagerLoader.getMatching(),
            "extraOptions": _options,
            "repository": _repository,
        ];
    }

    /**
     * Executes the query and converts the result set into Json.
     *
     * Part of JsonSerializable interface.
     *
     * @return DORMDatasource\IResultset The data to convert to Json.
     */
    function JsonSerialize(): IResultset
    {
        return _all();
    }

    /**
     * Sets whether the ORM should automatically append fields.
     *
     * By default calling select() will disable auto-fields. You can re-enable
     * auto-fields with this method.
     *
     * @param bool value Set true to enable, false to disable.
     */
    void enableAutoFields(bool value = true) {
        _autoFields = value;
    }

    /**
     * Disables automatically appending fields.
     *
     * @return this
     */
    function disableAutoFields() {
        _autoFields = false;

        return this;
    }

    /**
     * Gets whether the ORM should automatically append fields.
     *
     * By default calling select() will disable auto-fields. You can re-enable
     * auto-fields with enableAutoFields().
     *
     * @return bool|null The current value. Returns null if neither enabled or disabled yet.
     */
    bool isAutoFieldsEnabled(): ?bool
    {
        return _autoFields;
    }

    /**
     * Decorates the results iterator with MapReduce routines and formatters
     *
     * @param \Traversable result Original results
     * @return DORMDatasource\IResultset
     */
    protected function _decorateResults(Traversable result): IResultset
    {
        result = _applyDecorators(result);

        if (!(result instanceof Resultset) && this.isBufferedResultsEnabled()) {
            class = _decoratorClass();
            result = new class(result.buffered());
        }

        return result;
    } */
}