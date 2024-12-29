module uim.databases.interfaces.statement;

import uim.databases;

@safe:

interface IStatement {
    // Used to designate that numeric indexes be returned in a result when calling fetch methods
    const string FETCH_TYPE_NUM = "num";

    // Used to designate that an associated array be returned in a result when calling fetch methods
    const string FETCH_TYPE_ASSOC = "assoc";

    // Used to designate that a stdClass object be returned in a result when calling fetch methods
    const string FETCH_TYPE_OBJ = "obj";

    /**
     * Assign a value to a positional or named variable in prepared query. If using
     * positional variables you need to start with index one, if using named params then
     * just use the name in any order.
     *
     * It is not allowed to combine positional and named variables in the same statement.
     *
     * ### Examples:
     *
     * ```
     * statement.bindValue("active", true, "boolean");
     * ```
     */
    // void bindValue(Json binding);
    void bindValue(string column, Json value, string typeName = "string");

    /**
     * Closes a cursor in the database, freeing up any resources and memory
     * allocated to it. In most cases you don"t need to call this method, as it is
     * automatically called after fetching all results from the result set.
     */
    void closeCursor();

    // Returns the number of columns in the result set.
    int countColumns();

    // Returns the error code for the last error that occurred when executing this statement
    string errorCode();

    // Returns the error information for the last error that occurred when executing this statement
    Json[string] errorInfo();

    /**
     * Executes the statement by sending the SQL query to the database. It can optionally
     * take an array or arguments to be bound to the query variables. 
    */
    bool execute(Json[string] arguments = null);

    /**
     * Returns the next row for the result set after executing this statement.
     * Rows can be fetched to contain columns as names or positions. If no
     * rows are left in result set, this method will return false
     */
    Json fetch(string type = "num");

    // Returns an array with all rows resulting from executing this statement
    Json[string] fetchAll(string type = "num");

    // Returns the value of the result at position.
    Json fetchColumn(int position);

    /**
     * Fetches the next row from a result set using PDO.FETCH_ASSOC
     * and converts fields to types based on TypeMap.
     *
     * This behaves the same as `PDOStatement.fetch()` except an
     * empty array is returned instead of false.
     */
    Json[string] fetchAssoc();

    // Returns the number of rows affected by the last SQL statement.
    int rowCount();

    /**
     * Statements can be passed as argument for count()
     * to return the number for affected rows from last execution
     */
    size_t count();

    // Binds a set of values to statement object with corresponding type.
    void bind(Json[string] values, Json[string] types);

    // Returns the latest primary inserted using this statement.
    string lastInsertId(string tableName = null, string columnName = null);

    // Returns prepared query string.
    string queryString();

    // Get the bound params.
    Json[string] getBoundParams();
}
