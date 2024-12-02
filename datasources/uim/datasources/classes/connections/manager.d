module uim.datasources.classes.connections.manager;

import uim.datasources;

@safe:
/**
 * Manages and loads instances of Connection
 *
 * Provides an interface to loading and creating connection objects. Acts as
 * a registry for the connections defined in an application.
 */
class DConnectionManager : UIMObject {
    this() {
        super();
    }

    // Hook method
    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        // An array mapping url schemes to fully qualified driver class names
        // TODO
/*         _dsnClassMap = [
            "mysql": Mysql.classname,
            "postgres": Postgres.classname,
            "sqlite": Sqlite.classname,
            "sqlserver": Sqlserver.classname,
        ];
 */
        return true;
    }

    // An array mapping url schemes to fully qualified driver class names
    protected static STRINGAA _dsnClassMap;

    // The ConnectionRegistry used by the manager.
    protected static DDatasourceConnectionRegistry _registry;

    // #region connectionsAliases
    // A map of connection aliases.
    protected static STRINGAA _connectionAliases;
    /**
     * Set one or more connection aliases.
     *
     * Connection aliases allow you to rename active connections without overwriting
     * the aliased connection. This is most useful in the test-suite for replacing
     * connections with their test variant.
     *
     * Defined aliases will take precedence over normal connection names. For example,
     * if you alias "default" to "test", fetching "default" will always return the "test"
     * connection as long as the alias is defined.
     *
     * You can remove aliases with ConnectionManager.dropAlias().
     *
     * ### Usage
     *
     * ```
     * Make "things" resolve to "test_things" connection
     * ConnectionManager.alias("test_things", "things");
     * ```
     */
    static void connectionAlias(string connectionName, string aliasName) {
        _connectionAliases.set(aliasName, connectionName);
    }

    /**
     * Drop an alias.
     *
     * Removes an alias from ConnectionManager. Fetching the aliased
     * connection may fail if there is no other connection with that name.
     */
    static void dropConnectionAlias(string aliasName) {
        _connectionAliases.removeKey(aliasName);
    }

    // Returns the current connection aliases and what they alias.
    static STRINGAA connectionAliases() {
        return _connectionAliases.dup;
    }
}

unittest {
// TODO
}