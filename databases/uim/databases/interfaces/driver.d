module uim.databases.interfaces.driver;

import uim.databases;

@safe:

interface IDriver : INamed {
    // Establishes a connection to the database server.
    void connect();

    // String used to start a database identifier quoting to make it safe
    mixin(IProperty!("string", "startQuote"));

    // String used to end a database identifier quoting to make it safe
    mixin(IProperty!("string", "endQuote"));

    // Get / Set connection resource or object that is internally used.
    mixin(IProperty!("IConnection", "connection"));

    // Is able to use this driver for connecting to database.
    bool enabled();

    // Prepares a sql statement to be executed.
    IStatement prepare(IQuery query);

    // Starts a transaction.
    bool beginTransaction();

    // Commits a transaction - True on success, false otherwise.
    bool commitTransaction();

    // Rollbacks a transaction - True on success, false otherwise.
    bool rollbackTransaction();

    // Get the SQL for releasing a save point - myName Save point name or myid
    string releaseSavePointSQL(UUID myId);
    string releaseSavePointSQL(string myName);

    // Get the SQL for creating a save point.
    string savePointSQL(string savePointName);

    // Get the SQL for rollingback a save point.
    string rollbackSavePointSQL(string savePointName);

    // Get the SQL for disabling foreign keys.
    string disableForeignKeySQL();

    // Get the SQL for enabling foreign keys.
    string enableForeignKeySQL();

/**
     * Returns a value in a safe representation to be used in a query string
     *
     * @param mixed myValue The value to quote.
     * @param int myType Must be one of the \PDO.PARAM_* constants
     * /
    string quote(myValue, myType);


    /**
     * Returns a callable function that will be used to transform a passed Query object.
     * This function, in turn, will return an instance of a Query object that has been
     * transformed to accommodate any specificities of the SQL dialect in use.
     *
     * @param string myType The type of query to be transformed
     * (select, insert, update, delete).
     * @return \Closure
     * /
    Closure queryTranslator(string myType);

    /**
     * Get the schema dialect.
     *
     * Used by {@link uim.databases.Schema} package to reflect schema and
     * generate schema.
     *
     * If all the tables that use this Driver specify their
     * own schemas, then this may return null.
     *
     * @return uim.databases.Schema\SchemaDialect
     * /
    SchemaDialect schemaDialect();

    /**
     * Quotes a database identifier (a column name, table name, etc..) to
     * be used safely in queries without the risk of using reserved words.
     *
     * @param string myIdentifier The identifier expression to quote.
     */
    string quoteIdentifier(string myIdentifier);

    /**
     * Escapes values for use in schema definitions.
     *
     * @param mixed myValue The value to escape.
     * @return string String for use in schema definitions.
     * /
    string schemaValue(myValue);

    // Returns the schema name that"s being used.
    string schema();

    /**
     * Returns last id generated for a table or sequence in database.
     *
     * @param string|null myTable table name or sequence to get last insert value from.
     * @param string|null column the name of the column representing the primary key.
     */
    // string lastInsertId(string myTable = null, string column = null);

    // Checks whether the driver is connected.
    bool isConnected();

    /**
     * Sets whether this driver should automatically quote identifiers
     * in queries.
     *
     * @param bool myEnable Whether to enable auto quoting
     */
    O enableAutoQuoting(this O)(bool myEnable = true);

    // Disable auto quoting of identifiers in queries.
    O disableAutoQuoting(this O)();

    // Returns whether this driver should automatically quote identifiers in queries.
    bool isAutoQuotingEnabled();

    /**
     * Transforms the passed query to this Driver"s dialect and returns an instance
     * of the transformed query and the full compiled SQL string.
     *
     * @param uim.databases\Query myQuery The query to compile.
     * @param uim.databases\DValueBinder aValueBinder The value binder to use.
     * @return array containing 2 entries. The first entity is the transformed query
     * and the second one the compiled SQL.
     * /
    Json[string] compileQuery(Query myQuery, DValueBinder aValueBinder);

    // Returns an instance of a QueryCompiler.
    QueryCompiler newCompiler();

    /**
     * Constructs new DTableSchema.
     *
     * @param string myTable The table name.
     * @param Json[string] columns The list of columns for the schema.
     * @return uim.databases.Schema\TableSchema
     * /
    TableSchema newTableSchema(string myTable, Json[string] columns = []);
    
    // Disconnects from database server. 
    */
    void disconnect();
}