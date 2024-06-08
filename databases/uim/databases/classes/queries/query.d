module uim.databases.classes.queries.query;

import uim.databases;

@safe:

/**
 * This class represents a Relational database SQL Query. A query can be of
 * different types like select, update, insert and delete. Exposes the methods
 * for dynamically constructing each query part, execute it and transform it
 * to a specific SQL dialect.
 */
abstract class DQuery : IQuery { // : IExpression {
    mixin TConfigurable;
    // TODO mixin TTypeMap;

    // Hook method
    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        _parts = [
            "comment": Json(null),
            "delete": true.toJson,
            "update": Json.emptyArray,
            "set": Json.emptyArray,
            "insert": Json.emptyArray,
            "values": Json.emptyArray,
            "with": Json.emptyArray,
            "select": Json.emptyArray,
            "distinct": false.toJson,
            "modifier": Json.emptyArray,
            "from": Json.emptyArray,
            "join": Json.emptyArray,
            "where": Json(null),
            "group": Json.emptyArray,
            "having": Json(null),
            "window": Json.emptyArray,
            "order": Json(null),
            "limit": Json(null),
            "offset": Json(null),
            "union": Json.emptyArray,
            "epilog": Json(null),
        ];

        return true;
    }

    const string JOIN_TYPE_INNER = "INNER";

    const string JOIN_TYPE_LEFT = "LEFT";

    const string JOIN_TYPE_RIGHT = "RIGHT";

    const string TYPE_SELECT = "select";

    const string TYPE_INSERT = "insert";

    const string TYPE_UPDATE = "update";

    const string TYPE_DELETE = "delete";

    // Connection instance to be used to execute this query.
    protected IConnection _connection;

    // Connection role ("read' or "write")
    protected string _connectionRole; //  = Connection.ROLE_WRITE;

    // Type of this query (select, insert, update, delete).
    protected string _type;

    // Returns the type of this query (select, insert, update, delete)
    string type() {
        return _type;
    }

    // List of SQL parts that will be used to build this query.
    protected Json[string] _parts;

    /**
     * Indicates whether internal state of this query was changed, this is used to
     * discard internal cached objects such as the transformed query or the reference
     * to the executed statement.
     */
    protected bool _isDirty = false;

    protected IStatement _statement;

    /**
     * The object responsible for generating query placeholders and temporarily store values
     * associated to each of those.
     */
    protected IValueBinder _valueBinder;

    // Instance of functions builder object used for generating arbitrary SQL functions.
    protected DFunctionsBuilder _functionsBuilder;

    this(IConnection newConnection) {
        setConnection(newConnection);
    }
    
    // Sets the connection instance to be used for executing and transforming this query.
    void setConnection(Connection aConnection) {
       _isDirty();
       _connection = aConnection;
    }
    
    // Gets the connection instance to be used for executing and transforming this query.
    Connection getConnection() {
        return _connection;
    }
    
    // Returns the connection role ("read' or 'write")
    string getConnectionRole() {
        return _connectionRole;
    }
    
    /**
     * Compiles the SQL representation of this query and executes it using the
     * configured connection object. Returns the resulting statement object.
     *
     * Executing a query internally executes several steps, the first one is
     * letting the connection transform this object to fit its particular dialect,
     * this might result in generating a different Query object that will be the one
     * to actually be executed. Immediately after, literal values are passed to the
     * connection so they are bound to the query in a safe way. Finally, the resulting
     * statement is decorated with custom objects to execute callbacks for each row
     * retrieved if necessary.
     *
     * Resulting statement is traversable, so it can be used in any loop as you would
     * with an array.
     *
     * This method can be overridden in query subclasses to decorate behavior
     * around query execution.
     */
    IStatement execute() {
       _statement = null;
       _statement = _connection.run(this);
       _isDirty = false;

        return _statement;
    }
    
    /**
     * Executes the SQL of this query and immediately closes the statement before returning the row count of records
     * changed.
     *
     * This method can be used with UPDATE and DELETE queries, but is not recommended for SELECT queries and is not
     * used to count records.
     *
     * ## Example
     *
     * ```
     * rowCount = aQuery.set("articles")
     *               .set(["published'=>true])
     *               .where(["published'=>false])
     *               .rowCountAndClose();
     * ```
     *
     * The above example will change the published column to true for all false records, and return the number of
     * records that were updated.
     */
    int rowCountAndClose() {
        statement = this.execute();
        try {
            return statement.rowCount();
        } finally {
            statement.closeCursor();
        }
    }
    
    /**
     * Returns the SQL representation of this object.
     *
     * This auto will compile this query to make it compatible
     * with the SQL dialect that is used by the connection, This process might
     * add, remove or alter any query part or internal expression to make it
     * executable in the target platform.
     *
     * The resulting query may have placeholders that will be replaced with the actual
     * values when the query is executed, hence it is most suitable to use with
     * prepared statements.
     * Params:
     * \UIM\Database\DValueBinder|null aBinder Value binder that generates parameter placeholders
     */
    string sql(DValueBinder aBinder = null) {
        if (!aBinder) {
            aBinder = getValueBinder();
            aBinder.resetCount();
        }
        return _getConnection().getDriver().compileQuery(this, aBinder);
    }
    
    /**
     * Will iterate over every specified part. Traversing functions can aggregate
     * results using variables in the closure or instance variables. This function
     * is commonly used as a way for traversing all query parts that
     * are going to be used for constructing a query.
     *
     * The callback will receive 2 parameters, the first one is the value of the query
     * part that is being iterated and the second the name of such part.
     *
     * ### Example
     * ```
     * aQuery.select(["title"]).from("articles").traverse(function (aValue, clause) {
     *   if (clause == "Select") {
     *       var_dump(aValue);
     *   }
     * });
     * ```
     * Params:
     * \Closure aCallback Callback to be executed for each part
     */
    void traverse(Closure aCallback) {
        _parts.each!(namePart => aCallback(namePart.value, namePart.key));
    }
    
    /**
     * Will iterate over the provided parts.
     *
     * Traversing functions can aggregate results using variables in the closure
     * or instance variables. This method can be used to traverse a subset of
     * query parts in order to render a SQL query.
     *
     * The callback will receive 2 parameters, the first one is the value of the query
     * part that is being iterated and the second the name of such part.
     *
     * ### Example
     *
     * ```
     * aQuery.select(["title"]).from("articles").traverse(function (aValue, clause) {
     *   if (clause == "Select") {
     *       var_dump(aValue);
     *   }
     * }, ["select", "from"]);
     * ```
     * Params:
     */
    void traverseParts(Closure visitor, Json[string] queryParts) {
        someParts.each!(name =>  visitor(_parts[name], name));
    }
    
    /**
     * Adds a new common table expression (CTE) to the query.
     *
     * ### Examples:
     *
     * Common table expressions can either be passed as preconstructed expression
     * objects:
     *
     * ```
     * cte = new \UIM\Database\Expression\CommonTableExpression(
     *   'cte",
     *   aConnection
     *       .selectQuery("*")
     *       .from("articles")
     *);
     *
     * aQuery.with(cte);
     * ```
     *
     * or returned from a closure, which will receive a new common table expression
     * object as the first argument, and a new blank select query object as
     * the second argument:
     *
     * ```
     * aQuery.with(function (
     *   \UIM\Database\Expression\CommonTableExpression cte,
     *   \UIM\Database\Query aQuery
     *) {
     *   cteQuery = aQuery
     *       .select("*")
     *       .from("articles");
     *
     *   return cte
     *       .name("cte")
     *       .query(cteQuery);
     * });
     * ```
     */
    // TODO void with(Closure cteToAdd, bool shouldOverwrite = false) {
    void with(CommonTableExpression cteToAdd, bool shouldOverwrite = false) {
        if (shouldOverwrite) {
           _parts["with"] = null;
        }
        if (cast(DClosure)cte) {
            aQuery = getConnection().selectQuery();
            cte = cte(new DCommonTableExpression(), aQuery);
            if (!(cast(DCommonTableExpression)cte)) {
                throw new DException(
                    'You must return a `CommonTableExpression` from a Closure passed to `with()`.'
               );
            }
        }
       _parts["with"] ~= cte;
       _isDirty();

    
    /**
     * Adds a single or multiple `SELECT` modifiers to be used in the `SELECT`.
     *
     * By default this auto will append any passed argument to the list of modifiers
     * to be applied, unless the second argument is set to true.
     *
     * ### Example:
     *
     * ```
     * Ignore cache query in MySQL
     * aQuery.select(["name", "city"]).from("products").modifier("SQL_NO_CACHE");
     * It will produce the SQL: SELECT SQL_NO_CACHE name, city FROM products
     *
     * Or with multiple modifiers
     * aQuery.select(["name", "city"]).from("products").modifier(["HIGH_PRIORITY", "SQL_NO_CACHE"]);
     * It will produce the SQL: SELECT HIGH_PRIORITY SQL_NO_CACHE name, city FROM products
     * ```
     * Params:
     * \UIM\Database\/* IExpression| */ string[] amodifiers modifiers to be applied to the query
     */
    void modifier(/* IExpression| */ string[] amodifiers, bool shouldOverwrite = false) {
       _isDirty();
        if (shouldOverwrite) {
           _parts["modifier"] = null;
        }
        if (!isArray(someModifiers)) {
            someModifiers = [someModifiers];
        }
       _parts["modifier"] = array_merge(_parts["modifier"], someModifiers);
    }
    
    /**
     * Adds a single or multiple tables to be used in the FROM clause for this query.
     * Tables can be passed as an array of strings, Json[string] of expression
     * objects, a single expression or a single string.
     *
     * If an array is passed, keys will be used to alias tables using the value as the
     * real field to be aliased. It is possible to alias strings, IExpression objects or
     * even other Query objects.
     *
     * By default this auto will append any passed argument to the list of tables
     * to be selected from, unless the second argument is set to true.
     *
     * This method can be used for select, update and delete statements.
     *
     * ### Examples:
     *
     * ```
     * aQuery.from(["p": 'posts"]); // Produces FROM posts p
     * aQuery.from("authors"); // Appends authors: FROM posts p, authors
     * aQuery.from(["products"], true); // Resets the list: FROM products
     * aQuery.from(["sub": countQuery]); // FROM (SELECT ...) sub
     * ```
     */
    void from(string[] tableNames, bool shouldOverwrite = false) {
        if (tableNames.isEmpty) { return; }

        _parts["from"] = shouldOverwrite
            ? aTables
            : array_merge(_parts["from"], aTables);

       _isDirty();
    }
    
    /**
     * Adds a single or multiple tables to be used as JOIN clauses to this query.
     * Tables can be passed as an array of strings, an array describing the
     * join parts, an array with multiple join descriptions, or a single string.
     *
     * By default this auto will append any passed argument to the list of tables
     * to be joined, unless the third argument is set to true.
     *
     * When no join type is specified an `INNER JOIN` is used by default:
     * `aQuery.join(["authors"])` will produce `INNER JOIN authors ON 1 = 1`
     *
     * It is also possible to alias joins using the array key:
     * `aQuery.join(["a": 'authors"])` will produce `INNER JOIN authors a ON 1 = 1`
     *
     * A join can be fully described and aliased using the array notation:
     *
     * ```
     * aQuery.join([
     *   'a": [
     *       'table": 'authors",
     *       'type": 'LEFT",
     *       'conditions": 'a.id = b.author_id'
     *   ]
     * ]);
     * Produces LEFT JOIN authors a ON a.id = b.author_id
     * ```
     *
     * You can even specify multiple joins in an array, including the full description:
     *
     * ```
     * aQuery.join([
     *   "a": [
     *       "table": 'authors",
     *       "type": 'LEFT",
     *       "conditions": "a.id = b.author_id'
     *   ],
     *   "p": [
     *       "table": "publishers",
     *       "type": "INNER",
     *       "conditions": "p.id = b.publisher_id AND p.name = "uim Software Foundation"'
     *   ]
     * ]);
     * LEFT JOIN authors a ON a.id = b.author_id
     * INNER JOIN publishers p ON p.id = b.publisher_id AND p.name = "uim Software Foundation"
     * ```
     *
     * ### Using conditions and types
     *
     * Conditions can be expressed, as in the examples above, using a string for comparing
     * columns, or string with already quoted literal values. Additionally it is
     * possible to use conditions expressed in arrays or expression objects.
     *
     * When using arrays for expressing conditions, it is often desirable to convert
     * the literal values to the correct database representation. This is achieved
     * using the second parameter of this function.
     *
     * ```
     * aQuery.join(["a": [
     *   'table": 'articles",
     *   'conditions": [
     *       'a.posted >=": new DateTime("-3 days"),
     *       'a.published": true.toJson,
     *       'a.author_id = authors.id'
     *   ]
     * ]], ["a.posted": 'datetime", "a.published": 'boolean"])
     * ```
     *
     * ### Overwriting joins
     *
     * When creating aliased joins using the array notation, you can override
     * previous join definitions by using the same alias in consequent
     * calls to this auto or you can replace all previously defined joins
     * with another list if the third parameter for this bool is set to true.
     *
     * ```
     * aQuery.join(["alias": 'table"]); // joins table with as alias
     * aQuery.join(["alias": 'another_table"]); // joins another_table with as alias
     * aQuery.join(["something": 'different_table"], [], true); // resets joins list
     * ```
     * Params:
     * Json[string]|string atables list of tables to be joined in the query
    */
    auto join(string[] atables, Json[string] typeMap = null, bool shouldOverwrite = false) {
        if (isString(aTables) || isSet(aTables["table"])) {
            aTables = [aTables];
        }
        
        auto joins = null;
        anto anI = count(_parts["join"]);
        foreach (alias, t; aTables) {
            if (!isArray(t)) {
                t = ["table": t, "conditions": this.newExpr()];
            }
            if (cast(DClosure)t["conditions"]) {
                t["conditions"] = t["conditions"](this.newExpr(), this);
            }
            if (!cast(IExpression)t["conditions"]) {
                t["conditions"] = this.newExpr().add(t["conditions"], typeMap);
            }
            alias = isString(alias) ? alias : null;
             joins[alias ?:  anI++] = t ~ ["type": JOIN_TYPE_INNER, "alias": alias];
        }
        _parts["join"] = shouldOverwrite ?  joins : array_merge(_parts["join"],  joins);
       _isDirty();

        return this;
    }
    
    /**
     * Remove a join if it has been defined.
     *
     * Useful when you are redefining joins or want to re-order the join clauses.
     */
    auto removeJoin(string joinName) {
        _parts["join"].remove(joinName);
       _isDirty();

        return this;
    }
    
    /**
     * Adds a single `LEFT JOIN` clause to the query.
     *
     * This is a shorthand method for building joins via `join()`.
     *
     * The table name can be passed as a string, or as an array in case it needs to
     * be aliased:
     *
     * ```
     * LEFT JOIN authors ON authors.id = posts.author_id
     * aQuery.leftJoin("authors", "authors.id = posts.author_id");
     *
     * LEFT JOIN authors a ON a.id = posts.author_id
     * aQuery.leftJoin(["a": 'authors"], "a.id = posts.author_id");
     * ```
     *
     * Conditions can be passed as strings, arrays, or expression objects. When
     * using arrays it is possible to combine them with the `types` parameter
     * in order to define how to convert the values:
     *
     * ```
     * aQuery.leftJoin(["a": 'articles"], [
     *    'a.posted >=": new DateTime("-3 days"),
     *    'a.published": true.toJson,
     *    'a.author_id = authors.id'
     * ], ["a.posted": 'datetime", "a.published": 'boolean"]);
     * ```
     *
     * See `join()` for further details on conditions and types.
    */
    auto leftJoin(
        string[] tableNames,
        /* IExpression|Closure */string[] conditionsForJoin = null,
        Json[string] types = null
   ) {
        join(_makeJoin(tableNames, conditionsForJoin, JOIN_TYPE_LEFT), types);
    }
    
    /**
     * Adds a single `RIGHT JOIN` clause to the query.
     *
     * This is a shorthand method for building joins via `join()`.
     *
     * The arguments of this method are identical to the `leftJoin()` shorthand, please refer
     * to that methods description for further details.
     */
    void rightJoin(
        string[] tableNames,
        /* IExpression|Closure */string[] conditionsForJoining = null,
        Json[string] conditionTypes = null
   ) {
        join(_makeJoin(tableNames, conditionsForJoining, JOIN_TYPE_RIGHT), conditionTypes);
    }
    
    /**
     * Adds a single `INNER JOIN` clause to the query.
     *
     * This is a shorthand method for building joins via `join()`.
     *
     * The arguments of this method are identical to the `leftJoin()` shorthand, please refer
     * to that method`s description for further details.
     */
    void innerJoin(
        string[] tableNames,
        /* IExpression|Closure */string[] conditionsForJoining = null,
        Json[string] conditionTypes = null
   ) {
        join(_makeJoin(tableNames, conditionsForJoining, JOIN_TYPE_INNER), conditionTypes);
    }
    
    // Returns an array that can be passed to the join method describing a single join clause
    protected Json[string] _makeJoin(
        string[] tableNames,
        /* IExpression|Closure */ string[] conditionsForJoin,
        string joinType
   ) {
        string tableAlias = tableNames;

        if (isArray(tableNames)) {
            tableAlias = key(tableNames);
            tableToJoin = currentValue(tableNames);
        }

        return [
            tableAlias: [
                "table": tableToJoin,
                "conditions": conditionsForJoin,
                "type": joinType,
            ],
        ];
    }
    
    /**
     * Adds a condition or set of conditions to be used in the WHERE clause for this
     * query. Conditions can be expressed as an array of fields as keys with
     * comparison operators in it, the values for the array will be used for comparing
     * the field to such literal. Finally, conditions can be expressed as a single
     * string or an array of strings.
     *
     * When using arrays, each entry will be joined to the rest of the conditions using
     * an `AND` operator. Consecutive calls to this auto will also join the new
     * conditions specified using the AND operator. Additionally, values can be
     * expressed using expression objects which can include other query objects.
     *
     * Any conditions created with this methods can be used with any `SELECT`, `UPDATE`
     * and `DELETE` type of queries.
     *
     * ### Conditions using operators:
     *
     * ```
     * aQuery.where([
     *   'posted >=": new DateTime("3 days ago"),
     *   'title LIKE": 'Hello W%",
     *   'author_id": 1,
     * ], ["posted": 'datetime"]);
     * ```
     *
     * The previous example produces:
     *
     * `WHERE posted >= 2012-01-27 AND title LIKE 'Hello W%' AND author_id = 1`
     *
     * Second parameter is used to specify what type is expected for each passed
     * key. Valid types can be used from the mapped with Database\Type class.
     *
     * ### Nesting conditions with conjunctions:
     *
     * ```
     * aQuery.where([
     *   'author_id !=": 1,
     *   'OR": ["published": true.toJson, "posted <": new DateTime("now")],
     *   'NOT": ["title": 'Hello"]
     * ], ["published": boolean, "posted": 'datetime"]
     * ```
     *
     * The previous example produces:
     *
     * `WHERE author_id = 1 AND (published = 1 OR posted < '2012-02-01") AND NOT (title = "Hello")`
     *
     * You can nest conditions using conjunctions as much as you like. Sometimes, you
     * may want to define 2 different options for the same key, in that case, you can
     * wrap each condition inside a new array:
     *
     * `aQuery.where(["OR": [["published": false.toJson], ["published": true.toJson]])`
     *
     * Would result in:
     *
     * `WHERE (published = false) OR (published = true)`
     *
     * Keep in mind that every time you call where() with the third param set to false
     * (default), it will join the passed conditions to the previous stored list using
     * the `AND` operator. Also, using the same array key twice in consecutive calls to
     * this method will not override the previous value.
     *
     * ### Using expressions objects:
     *
     * ```
     * exp = aQuery.newExpr().add(["id !=": 100, "author_id' != 1]).tieWith("OR");
     * aQuery.where(["published": true.toJson], ["published": 'boolean"]).where(exp);
     * ```
     *
     * The previous example produces:
     *
     * `WHERE (id != 100 OR author_id != 1) AND published = 1`
     *
     * Other Query objects that be used as conditions for any field.
     *
     * ### Adding conditions in multiple steps:
     *
     * You can use callbacks to construct complex expressions, functions
     * receive as first argument a new QueryExpression object and this query instance
     * as second argument. Functions must return an expression object, that will be
     * added the list of conditions for the query using the `AND` operator.
     *
     * ```
     * aQuery
     * .where(["title !=": 'Hello World"])
     * .where(function (exp, aQuery) {
     *    or = exp.or(["id": 1]);
     *   and = exp.and(["id >": 2, "id <": 10]);
     *  return or.add(and);
     * });
     * ```
     *
     * * The previous example produces:
     *
     * `WHERE title != "Hello World' AND (id = 1 OR (id > 2 AND id < 10))`
     *
     * ### Conditions as strings:
     *
     * ```
     * aQuery.where(["articles.author_id = authors.id", "modified isNull"]);
     * ```
     *
     * The previous example produces:
     *
     * `WHERE articles.author_id = authors.id AND modified isNull`
     *
     * Please note that when using the array notation or the expression objects, all
     * *values* will be correctly quoted and transformed to the correspondent database
     * data type automatically for you, thus securing your application from SQL injections.
     * The keys however, are not treated as unsafe input, and should be validated/sanitized.
     *
     * If you use string conditions make sure that your values are correctly quoted.
     * The safest thing you can do is to never use string conditions.
     *
     * ### Using null-able values
     *
     * When using values that can be null you can use the 'IS' keyword to let the ORM generate the correct SQL based on the value`s type
     *
     * ```
     * aQuery.where([
     *   'posted >=": new DateTime("3 days ago"),
     *   'category_id IS": category,
     * ]);
     * ```
     *
     * If category is `null` - it will actually convert that into `category_id isNull` - if it`s `4` it will convert it into `category_id = 4`
     */
    void where(
        /* IExpression|Closure */ string[] conditionsToFilter = null,
        Json[string] types = null,
        bool shouldOverwrite = false
   ) {
        if (shouldOverwrite) {
           _parts["where"] = this.newExpr();
        }
       _conjugate("where", conditionsToFilter, "AND", types);
    }
    
    /**
     * Convenience method that adds a NOT NULL condition to the query
     * Params:
     * \UIM\Database\/* IExpression| */ string[] fieldNames A single field or expressions or a list of them
     * that should be not null.
     */
    auto whereNotNull(/* IExpression| */ string[] fieldNames) {
        if (!isArray(fields)) {
            fields = [fields];
        }
        auto newExpression = this.newExpr();

        fields.each!(field => newExpression.isNotNull(field));
        return _where(newExpression);
    }
    
    /**
     * Convenience method that adds a isNull condition to the query
     * Params:
     * \UIM\Database\/* IExpression| */ string[] fieldNames A single field or expressions or a list of them
     * that should be null.
     */
    auto whereNull(/* IExpression| */ string[] fieldNames) {
        if (!isArray(fields)) {
            fields = [fields];
        }

        auto newExpression = this.newExpr();
        fields.each!(field => newExpression.isNull(field));
        return _where(newExpression);
    }
    
    /**
     * Adds an IN condition or set of conditions to be used in the WHERE clause for this
     * query.
     *
     * This method does allow empty inputs in contrast to where() if you set
     * 'allowEmpty' to true.
     * Be careful about using it without proper sanity checks.
     */
    auto whereInList(string fieldName, Json[string] someValues, Json[string] options = null) {
        // `types` - Associative array of type names used to bind values to query
        options["types"] = ArrayData;

        // `allowEmpty` - Allow empty array.
        options["allowEmpty"] = false.toJson;

        if (options["allowEmpty"].toBoolean && !someValues) {
            return _where("1=0");
        }

        return _where([fieldName ~ " IN": someValues], options["types"]);
    }
    
    /**
     * Adds a NOT IN condition or set of conditions to be used in the WHERE clause for this
     * query.
     *
     * This method does allow empty inputs in contrast to where() if you set
     * 'allowEmpty' to true.
     * Be careful about using it without proper sanity checks.
     */
    auto whereNotInList(string fieldName, Json[string] someValues, Json[string] options = null) {
        auto auto updatedOptions = options.update([
            "types": Json.emptyArray,
            "allowEmpty": false.toJson
        ];

        if (options["allowEmpty"] && !someValues) {
            return _where([fieldName ~ " IS NOT": Json(null)]);
        }

        return _where([fieldName ~ " NOT IN": someValues], options["types"]);
    }
    
    /**
     * Adds a NOT IN condition or set of conditions to be used in the WHERE clause for this
     * query. This also allows the field to be null with a isNull condition since the null
     * value would cause the NOT IN condition to always fail.
     *
     * This method does allow empty inputs in contrast to where() if you set
     * 'allowEmpty' to true.
     * Be careful about using it without proper sanity checks.
     */
    auto whereNotInListOrNull(string fieldName, Json[string] someValues, Json[string] options = null) {
        auto auto updatedOptions = options.update() [
            "types": Json.emptyArray,
            "allowEmpty": false.toJson,
        ];

        if (options["allowEmpty"] && !someValues) {
            return _where([fieldName ~ " IS NOT": Json(null)]);
        }

        return _where(
            [
                "OR": [fieldName ~ " NOT IN": someValues, fieldName ~ " IS": Json(null)],
            ],
            options["types"]
       );
    }
    
    /**
     * Connects any previously defined set of conditions to the provided list
     * using the AND operator. This auto accepts the conditions list in the same
     * format as the method `where` does, hence you can use arrays, expression objects
     * callback functions or strings.
     *
     * It is important to notice that when calling this function, any previous set
     * of conditions defined for this query will be treated as a single argument for
     * the AND operator. This auto will not only operate the most recently defined
     * condition, but all the conditions as a whole.
     *
     * When using an array for defining conditions, creating constraints form each
     * Json[string] entry will use the same logic as with the `where()` function. This means
     * that each array entry will be joined to the other using the AND operator, unless
     * you nest the conditions in the array using other operator.
     *
     * ### Examples:
     *
     * ```
     * aQuery.where(["title": 'Hello World").andWhere(["author_id": 1]);
     * ```
     *
     * Will produce:
     *
     * `WHERE title = "Hello World' AND author_id = 1`
     *
     * ```
     * aQuery
     * .where(["OR": ["published": false.toJson, "published isNull"]])
     * .andWhere(["author_id": 1, "comments_count >": 10])
     * ```
     *
     * Produces:
     *
     * `WHERE (published = 0 OR published isNull) AND author_id = 1 AND comments_count > 10`
     *
     * ```
     * aQuery
     * .where(["title": 'Foo"])
     * .andWhere(function (exp, aQuery) {
     *   return exp
     *     .or(["author_id": 1])
     *     .add(["author_id": 2]);
     * });
     * ```
     *
     * Generates the following conditions:
     *
     * `WHERE (title = "Foo") AND (author_id = 1 OR author_id = 2)`
     */
    void andWhere(/* IExpression|Closure */string[] conditionsToAdd, Json[string] typeNames = null) {
       _conjugate("where", conditionsToAdd, "AND", typeNames);
    }
    
    /**
     * Adds a single or multiple fields to be used in the ORDER clause for this query.
     * Fields can be passed as an array of strings, Json[string] of expression
     * objects, a single expression or a single string.
     *
     * If an array is passed, keys will be used as the field itself and the value will
     * represent the order in which such field should be ordered. When called multiple
     * times with the same fields as key, the last order definition will prevail over
     * the others.
     *
     * By default this auto will append any passed argument to the list of fields
     * to be selected, unless the second argument is set to true.
     *
     * ### Examples:
     *
     * ```
     * aQuery.orderBy(["title": 'DESC", "author_id": 'ASC"]);
     * ```
     *
     * Produces:
     *
     * `ORDER BY title DESC, author_id ASC`
     *
     * ```
     * aQuery
     *   .orderBy(["title": aQuery.newExpr("DESC NULLS FIRST")])
     *   .orderBy("author_id");
     * ```
     *
     * Will generate:
     *
     * `ORDER BY title DESC NULLS FIRST, author_id`
     *
     * ```
     * expression = aQuery.newExpr().add(["id % 2 = 0"]);
     * aQuery.orderBy(expression).orderBy(["title": 'ASC"]);
     * ```
     *
     * and
     *
     * ```
     * aQuery.orderBy(function (exp, aQuery) {
     *   return [exp.add(["id % 2 = 0"]), "title": 'ASC"];
     * });
     * ```
     *
     * Will both become:
     *
     * `ORDER BY (id %2 = 0), title ASC`
     *
     * DOrder fields/directions are not sanitized by the query builder.
     * You should use an allowed list of fields/directions when passing
     * in user-supplied data to `order()`.
     *
     * If you need to set complex expressions as order conditions, you
     * should use `orderByAsc()` or `orderByDesc()`.
     */
    void orderBy(/* /* IExpression|Closure */ */ string[] fieldNames, bool shouldOverwrite = false) {
        if (shouldOverwrite) {
           _parts["order"] = null;
        }
        if (!fieldNames) {
            return;
        }
        if (!_parts["order"]) {
           _parts["order"] = new DOrderByExpression();
        }
       _conjugate("order", fieldNames, "", []);
    }
    
    /**
     * Add an ORDER BY clause with an ASC direction.
     *
     * This method allows you to set complex expressions
     * as order conditions unlike order()
     *
     * DOrder fields are not suitable for use with user supplied data as they are
     * not sanitized by the query builder.
     */
    void orderByAsc(/* /* IExpression|Closure */ */ string fieldName, bool shouldOverwrite = false) {
        if (shouldOverwrite) {
           _parts["order"] = null;
        }
        if (!fieldName) {
            return;
        }
        if (cast(DClosure)fieldName) {
            fieldName = field(this.newExpr(), this);
        }
        if (!_parts["order"]) {
           _parts["order"] = new DOrderByExpression();
        }
       _parts["order"].add(new DOrderClauseExpression(fieldName, "ASC"));
    }
    
    /**
     * Add an ORDER BY clause with a DESC direction.
     *
     * This method allows you to set complex expressions
     * as order conditions unlike order()
     *
     * DOrder fields are not suitable for use with user supplied data as they are
     * not sanitized by the query builder.
     * Params:
     * \UIM\Database\IExpression|\Closure|string fieldName The field to order on.
      */
    auto orderByDesc(/* IExpression|Closure */string fieldName, bool shouldOverwrite = false) {
        if (shouldOverwrite) {
           _parts["order"] = null;
        }
        if (!field) {
            return this;
        }
        if (cast8Closure)field) {
            field = field(this.newExpr(), this);
        }
        if (!_parts["order"]) {
           _parts["order"] = new DOrderByExpression();
        }
       _parts["order"].add(new DOrderClauseExpression(field, "DESC"));

        return this;
    }
    
    /**
     * Set the page of results you want.
     *
     * This method provides an easier to use interface to set the limit + offset
     * in the record set you want as results. If empty the limit will default to
     * the existing limit clause, and if that too is empty, then `25` will be used.
     *
     * Pages must start at 1.
     */
    auto page(int pageNumber, int limitNumberRows = null) {
        throw new DException("Not implemented");
    }
    
    /**
     * Sets the number of records that should be retrieved from database,
     * accepts an integer or an expression object that evaluates to an integer.
     * In some databases, this operation might not be supported or will require
     * the query to be transformed in order to limit the result set size.
     *
     * ### Examples
     *
     * ```
     * aQuery.limit(10) // generates LIMIT 10
     * aQuery.limit(aQuery.newExpr().add(["1 + 1"])); // LIMIT (1 + 1)
     * ```
     * Params:
     * \UIM\Database\IExpression|int aLimit number of records to be returned
     */
    auto limit(IExpression|int aLimit) {
       _isDirty();
       _parts["limit"] = aLimit;

        return this;
    }
    
    /**
     * Sets the number of records that should be skipped from the original result set
     * This is commonly used for paginating large results. Accepts an integer or an
     * expression object that evaluates to an integer.
     *
     * In some databases, this operation might not be supported or will require
     * the query to be transformed in order to limit the result set size.
     *
     * ### Examples
     *
     * ```
     * aQuery.offset(10) // generates OFFSET 10
     * aQuery.offset(aQuery.newExpr().add(["1 + 1"])); // OFFSET (1 + 1)
     * ```
     * Params:
     * \UIM\Database\IExpression|int anOffset number of records to be skipped
     */
    auto offset(IExpression|int anOffset) {
       _isDirty();
       _parts["offset"] = anOffset;

        return this;
    }
    
    /**
     * Creates an expression that refers to an identifier. Identifiers are used to refer to field names and allow
     * the SQL compiler to apply quotes or escape the identifier.
     *
     * The value is used as is, and you might be required to use aliases or include the table reference in
     * the identifier. Do not use this method to inject SQL methods or logical statements.
     *
     * ### Example
     *
     * ```
     * aQuery.newExpr().lte("count", aQuery.identifier("total"));
     * ```
     * Params:
     * string aidentifier The identifier for an expression
     */
    IExpression identifier(string aidentifier) {
        return new DIdentifierExpression(anIdentifier);
    }
    
    /**
     * A string or expression that will be appended to the generated query
     *
     * ### Examples:
     * ```
     * aQuery.select("id").where(["author_id": 1]).epilog("FOR UPDATE");
     * aQuery
     * .insert("articles", ["title"])
     * .values(["author_id": 1])
     * .epilog("RETURNING id");
     * ```
     *
     * Epliog content is raw SQL and not suitable for use with user supplied data.
     * Params:
     * \UIM\Database\/* IExpression| */ string expression The expression to be appended
     */
    auto epilog(/* IExpression| */ string expression = null) {
       _isDirty();
       _parts["epilog"] = expression;

        return this;
    }
    
    /**
     * A string or expression that will be appended to the generated query as a comment
     *
     * ### Examples:
     * ```
     * aQuery.select("id").where(["author_id": 1]).comment("Filter for admin user");
     * ```
     *
     * Comment content is raw SQL and not suitable for use with user supplied data.
     * Params:
     * string expression The comment to be added
     */
    auto comment(string aexpression = null) {
       _isDirty();
       _parts["comment"] = expression;

        return this;
    }
    
    /**
     * Returns the type of this query (select, insert, update, delete)
     */
    string type() {
        return _type;
    }
    
    /**
     * Returns a new QueryExpression object. This is a handy auto when
     * building complex queries using a fluent interface. You can also override
     * this auto in subclasses to use a more specialized QueryExpression class
     * if required.
     *
     * You can optionally pass a single raw SQL string or an array or expressions in
     * any format accepted by \UIM\Database\Expression\QueryExpression:
     *
     * ```
     * expression = aQuery.expr(); // Returns an empty expression object
     * expression = aQuery.expr("Table.column = Table2.column"); // Return a raw SQL expression
     * ```
     * Params:
     * \UIM\Database\/* IExpression| */ string[] rawExpression A string, Json[string] or anything you want wrapped in an expression object
     */
    QueryExpression newExpr(/* IExpression| */ string[] rawExpression = null) {
        return _expr(rawExpression);
    }
    
    /**
     * Returns a new QueryExpression object. This is a handy auto when
     * building complex queries using a fluent interface. You can also override
     * this auto in subclasses to use a more specialized QueryExpression class
     * if required.
     *
     * You can optionally pass a single raw SQL string or an array or expressions in
     * any format accepted by \UIM\Database\Expression\QueryExpression:
     *
     * ```
     * expression = aQuery.expr(); // Returns an empty expression object
     * expression = aQuery.expr("Table.column = Table2.column"); // Return a raw SQL expression
     * ```
     * Params:
     * \UIM\Database\/* IExpression| */ string[] rawExpression A string, Json[string] or anything you want wrapped in an expression object
     */
    QueryExpression expr(/* IExpression| */ string[] rawExpression = null) {
        expression = new DQueryExpression([], getTypeMap());

        if (!rawExpressionisNull) {
            expression.add(rawExpression);
        }
        return expression;
    }
    
    /**
     * Returns an instance of a functions builder object that can be used for
     * generating arbitrary SQL functions.
     *
     * ### Example:
     *
     * ```
     * aQuery.func().count("*");
     * aQuery.func().dateDiff(["2012-01-05", "2012-01-02"])
     * ```
     */
    FunctionsBuilder func() {
        return _functionsBuilder ??= new DFunctionsBuilder();
    }
    
    /**
     * Returns any data that was stored in the specified clause. This is useful for
     * modifying any internal part of the query and it is used by the SQL dialects
     * to transform the query accordingly before it is executed. The valid clauses that
     * can be retrieved are: delete, update, set, insert, values, select, distinct,
     * from, join, set, where, group, having, order, limit, offset and union.
     *
     * The return value for each of those parts may vary. Some clauses use QueryExpression
     * to internally store their state, some use arrays and others may use booleans or
     * integers. This is summary of the return types for each clause.
     *
     * - update: string The name of the table to update
     * - set: QueryExpression
     * - insert: array, will return an array containing the table + columns.
     * - values: ValuesExpression
     * - select: array, will return empty array when no fields are set
     * - distinct: boolean
     * - from: array of tables
     * - join: array
     * - set: array
     * - where: QueryExpression, returns null when not set
     * - group: array
     * - having: QueryExpression, returns null when not set
     * - order: DOrderByExpression, returns null when not set
     * - limit: integer or QueryExpression, null when not set
     * - offset: integer or QueryExpression, null when not set
     * - union: array
     */
    Json clause(string clauseName) {
        if (!array_key_exists(clauseName, _parts)) {
            clauses = _parts.keys;
            array_walk(clauses, fn (&$x): $x = "`$x`");
            clauses = join(", ", clauses);
            throw new DInvalidArgumentException(
                "The `%s` clause is not defined. Valid clauses are: %s."
                .format(clauseName, clauses)
           );
        }
        return _parts[name];
    }
    
    /**
     * This auto works similar to the traverse() function, with the difference
     * that it does a full depth traversal of the entire expression tree. This will execute
     * the provided callback auto for each IExpression object that is
     * stored inside this query at any nesting depth in any part of the query.
     *
     * Callback will receive as first parameter the currently visited expression.
     * Params:
     * \Closure aCallback the auto to be executed for each IExpression
     * found inside this query.
     */
    void traverseExpressions(Closure aCallback) {
        _parts
            .each!(part => _expressionsVisitor(part, aCallback));
    }
    
    // Query parts traversal method used by traverseExpressions()
    protected void _expressionsVisitor(Json[] queryExpressions, IClosure aCallback) {
        queryExpressions
            .each!(exp => expressionsVisitor(exp, aCallback));
    }
    
    protected void _expressionsVisitor(Json expression, IClosure aCallback) {
        if (cast(IExpression)expression) {
            expression.traverse(fn (exp): _expressionsVisitor(exp, aCallback));

            if (!cast(self)expression) {
                aCallback(expression);
            }
        }
    }
    
    /**
     * Associates a query placeholder to a value and a type.
     *
     * ```
     * aQuery.bind(": id", 1, "integer");
     * ```
     */
    void bind(string placeholderToQuote, Json valueToBound, string typeName = null) {
        getValueBinder().bind(placeholderToQuote, valueToBound, typeName);
    }
    
    /**
     * Returns the currently used DValueBinder instance.
     *
     * A DValueBinder is responsible for generating query placeholders and temporarily
     * associate values to those placeholders so that they can be passed correctly
     * to the statement object.
     */
    DValueBinder getValueBinder() {
        return _valueBinder.ifNull(new DValueBinder());
    }
    
    /**
     * Overwrite the current value binder
     *
     * A DValueBinder is responsible for generating query placeholders and temporarily
     * associate values to those placeholders so that they can be passed correctly
     * to the statement object.
     * Params:
     * \UIM\Database\DValueBinder|null aBinder The binder or null to disable binding.
     */
    void setValueBinder(DValueBinder aBinder) {
       _valueBinder = aBinder;
    }
    
    // Helper auto used to build conditions by composing QueryExpression objects.
    protected void _conjugate(
        string queryPart,
        /* /* IExpression|Closure */ */ string[] appendExpression,
        string conjunctionType,
        Json[string] typesNames
   ) {
        expression = _parts[queryPart] ?: this.newExpr();
        if (isEmpty(append)) {
           _parts[queryPart] = expression;

            return;
        }
        if (cast(DClosure)append) {
            append = append(this.newExpr(), this);
        }
        if (expression.conjunctionType() == conjunctionType) {
            expression.add(append, typesNames);
        } else {
            expression = this.newExpr()
                .conjunctionType(conjunctionType)
                .add([expression, append], typesNames);
        }
       _parts[queryPart] = expression;
       _isDirty();
    }
    
    /**
     * Marks a query as dirty, removing any preprocessed information
     * from in memory caching.
     */
    protected void _isDirty() {
       _isDirty = true;

        if (_statement && _valueBinder) {
            getValueBinder().reset();
        }
    }
    
    // Handles clearing iterator and cloning all expressions and value binders.
    void clone() {
       _statement = null;
        if (!_valueBinder.isNull) {
           _valueBinder = clone _valueBinder;
        }
        _parts.byKeyValue
            .filter!(namePart => !isEmpty(part))
            .each!(namePart => 
            if (namePart.value.isArray) {
                foreach (anI: piece; namePart.value) {
                    if (isArray(piece)) {
                        foreach (piece as  j: aValue) {
                            if (cast(IExpression)aValue) {
                               _parts[namePart.key][anI][j] = clone aValue;
                            }
                        }
                    } elseif (cast(IExpression)piece) {
                       _parts[namePart.key][anI] = clone piece;
                    }
                }
            }
            if (cast(IExpression)namePart.value) {
               _parts[namePart.key] = clone namePart.value;
            }
        }
    }
    
    // Returns string representation of this query (complete SQL statement).
    override string toString() {
        return _sql();
    }
    
    // Returns an array that can be used to describe the internal state of this object.
    Json[string] debugInfo() {
        auto mySql = "SQL could not be generated for this query as it is incomplete.";
        params = null;
        try {
            set_error_handler(
                void (errno, errstr) {
                    throw new DException(errstr, errno);
                },
                E_ALL
           );
            mySql = this.sql();
            params = getValueBinder().bindings();
        } catch (Throwable  anException) {
            mySql = "SQL could not be generated for this query as it is incomplete.";
            params = null;
        } finally {
            restore_error_handler();

            return [
                "(help)": "This is a Query object, to get the results execute or iterate it.",
                "sql": Json(mySql),
                "params": Json(params),
                "defaultTypes": Json(getDefaultTypes()),
                "executed": Json((bool)_statement),
            ];
        }
    }
}
