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

    // A map of connection aliases.
    protected static STRINGAA _connectionAliases;

    // An array mapping url schemes to fully qualified driver class names
    protected static STRINGAA _dsnClassMap;

    // The ConnectionRegistry used by the manager.
    protected static DDatasourceConnectionRegistry _registry;
}

unittest {
// TODO
}