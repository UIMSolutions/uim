module uim.databases.interfaces.statement;

import uim.databases;

@safe:

interface IStatement {
    /**
     * Maps to PDO.FETCH_NUM.
     */
    const string FETCH_TYPE_NUM = "num";

    /**
     * Maps to PDO.FETCH_ASSOC.
     */
    const string FETCH_TYPE_ASSOC = "assoc";

    // Maps to PDO.FETCH_OBJ.
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
     * statement.bindValue(1, "a title");
     * statement.bindValue("active", true, "boolean");
     * statement.bindValue(5, new \DateTime(), "date");
     * ```
     */
    void bindValue(string|int column, Json valueToBind, string typeName = "string");

    /**
     * Closes the cursor, enabling the statement to be executed again.
     *
     * This behaves the same as `PDOStatement.closeCursor()`.
     */
    void closeCursor();

    /**
     * Returns the number of columns in the result set.
     *
     * This behaves the same as `PDOStatement.columnCount()`.
     */
    int columnCount();

    /**
     * Fetch the SQLSTATE associated with the last operation on the statement handle.
     *
     * This behaves the same as `PDOStatement.errorCode()`.
     */
    string errorCode();

    /**
     * Fetch extended error information associated with the last operation on the statement handle.
     *
     * This behaves the same as `PDOStatement.errorInfo()`.
     */
    Json[string] errorInfo();

    /**
     * Executes the statement by sending the SQL query to the database. It can optionally
     * take an array or arguments to be bound to the query variables. Please note
     * that binding parameters from this method will not perform any custom type conversion
     * as it would normally happen when calling `bindValue`.
     * Params:
     * array|null params list of values to be bound to query
      */
    bool execute(Json[string] params = null);

    /**
     * Fetches the next row from a result set
     * and converts fields to types based on TypeMap.
     *
     * This behaves the same as `PDOStatement.fetch()`.
     * Params:
     * string|int mode PDO.FETCH_* constant or fetch mode name.
     * Valid names are 'assoc", "num' or 'obj'.
     */
    Json fetch(string|int mode = PDO.FETCH_NUM);

    /**
     * Fetches the remaining rows from a result set
     * and converts fields to types based on TypeMap.
     *
     * This behaves the same as `PDOStatement.fetchAll()`.
     * Params:
     * string|int mode PDO.FETCH_* constant or fetch mode name.
     * Valid names are 'assoc", "num' or 'obj'.
     */
    Json[string] fetchAll(string|int mode = PDO.FETCH_NUM);

    /**
     * Fetches the next row from a result set using PDO.FETCH_NUM
     * and converts fields to types based on TypeMap.
     *
     * This behaves the same as `PDOStatement.fetch()` except only
     * a specific column from the row is returned.
    */
    Json fetchColumn(size_t columnIndex);

    /**
     * Fetches the next row from a result set using PDO.FETCH_ASSOC
     * and converts fields to types based on TypeMap.
     *
     * This behaves the same as `PDOStatement.fetch()` except an
     * empty array is returned instead of false.
     */
    Json[string] fetchAssoc();

    /**
     * Returns the number of rows affected by the last SQL statement.
     *
     * This behaves the same as `PDOStatement.rowCount()`.
     */
    int rowCount();

    /**
     * Binds a set of values to statement object with corresponding type.
     * Params:
     * Json[string] params list of values to be bound
     */
    void bind(Json[string] params, Json[string] listOfTypes);

    /**
     * Returns the latest primary inserted using this statement.
     * Params:
     * string aTable table name or sequence to get last insert value from
     * @param string column the name of the column representing the primary key
     */
    string|int lastInsertId(string atable = null, string acolumn = null);

    // Returns prepared query string.
    string queryString();

    /**
     * Get the bound params.
     */
    Json[string] getBoundParams();
    */
}
