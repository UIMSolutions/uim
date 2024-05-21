/*********************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        *
*	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  *
*	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      *
**********************************************************************************************************/
module uim.datasources.classes.connections.manager;

@safe:
import uim.datasources;

/**
 * Manages and loads instances of Connection
 *
 * Provides an interface to loading and creating connection objects. Acts as
 * a registry for the connections defined in an application.
 */
class DConnectionManager {
    mixin TConfigurable;

  this() {
    initialize;
  }
  
  // Hook method
  bool initialize(Json[string] initData = null) {

    configuration(MemoryConfiguration);
    configuration.data(initData);

       // An array mapping url schemes to fully qualified driver class names
    _dsnClassMap = [
            "mysql": Mysql.classname,
            "postgres": Postgres.classname,
            "sqlite": Sqlite.classname,
            "sqlserver": Sqlserver.classname,
        ];

    return true;
  }
 
        return true;
    }

    // A map of connection aliases.
    protected static STRINGAA _connectionAliases;

    // An array mapping url schemes to fully qualified driver class names
    protected static STRINGAA _dsnClassMap;


    // The ConnectionRegistry used by the manager.
    protected static DConnectionRegistry _registry;

        /*
    mixin template TStaticConfig() {
        setConfig as protected _setConfig;
        parseDsn as protected _parseDsn;
    }
;

    /**
     * Configure a new connection object.
     *
     * The connection will not be constructed until it is first used.
     * Params:
     * Json[string]|string aKey The name of the connection config, or an array of multiple configs.
     * @param \UIM\Datasource\IConnection|\Closure|Json[string]|null configData An array of name: config data for adapter.
     */
    static void configuration.update(string[] aKey, /* IConnection | Closure */ | array | null configData = null) {
        if (isArray(configData)) {
            configuration.get("name", aKey);
        }
        configuration.update(aKey, configData);
    }

    /**
     * Parses a DSN into a valid connection configuration
     *
     * This method allows setting a DSN using formatting similar to that used by PEAR.DB.
     * The following is an example of its usage:
     *
     * ```
     * dsn = "mysql://user:pass@localhost/database";
     * myConfiguration = ConnectionManager.parseDsn(dsn);
     *
     * dsn = "uim\databases.Driver\Mysql://localhost:3306/database?className=uim\databases.Connection";
     * myConfiguration = ConnectionManager.parseDsn(dsn);
     *
     * dsn = "uim\databases.Connection://localhost:3306/database?driver=uim\databases.Driver\Mysql";
     * myConfiguration = ConnectionManager.parseDsn(dsn);
     * ```
     *
     * For all classes, the value of `scheme` is set as the value of both the `className` and `driver`
     * unless they have been otherwise specified.
     *
     * Note that query-string arguments are also parsed and set as values in the returned configuration.
     */
    static Json[string] parseDsn(string dsnToConvert) {
        auto data = _parseDsn(dsnToConvert);

        if (data.isSet("path") && data.isEmpty("database")) {
            data["database"] = substr(data.getString("path"), 1);
        }

        if (data.isEmpty("driver")) {
            data["driver"] = data.getString("className"];
            data["className"] = DConnection.class;
        }
        data.remove("path");

        return data;
    }

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
    static void alias(string sourceConnection, string aliasName) {
        _aliasMap[aliasName] = sourceConnection;
    }

    /**
     * Drop an alias.
     *
     * Removes an alias from ConnectionManager. Fetching the aliased
     * connection may fail if there is no other connection with that name.
     */
    static void dropAlias(aliasToDrop) {
        unset(_aliasMap[aliasToDrop]);
    }

    /**
     * Get a connection.
     *
     * If the connection has not been constructed an instance will be added
     * to the registry. This method will use any aliases that have been
     * defined. If you want the original unaliased connections pass `false`
     * as second parameter.
     */
    static IConnection get(string connectionName, bool useAliases = true) {
        if (useAliases && isset(_aliasMap[connectionName])) {
            connectionName = _aliasMap[connectionName];
        }
        if (configuration.isEmpty(connectionName)) {
            throw new DMissingDatasourceConfigException(["name": connectionName]);
        }
        /** @psalm-suppress RedundantPropertyInitializationCheck  */
        if (!isset(_registry)) {
            _registry = new DConnectionRegistry();
        }

        return _registry. {
            connectionName
        }
        
        ?  ? _registry.load(connectionName, configuration.get(connectionName));
    } 
}
/**
     * Parses a DSN into a valid connection configuration
     *
     * This method allows setting a DSN using formatting similar to that used by PEAR.DB.
     * The following is an example of its usage:
     *
     * ```
     * dsn = "mysql://user:pass@localhost/database";
     * configData = ConnectionManager.parseDsn(dsn);
     *
     * dsn = "UIM\Database\Driver\Mysql://localhost:3306/database?className=UIM\Database\Connection";
     * configData = ConnectionManager.parseDsn(dsn);
     *
     * dsn = "UIM\Database\Connection://localhost:3306/database?driver=UIM\Database\Driver\Mysql";
     * configData = ConnectionManager.parseDsn(dsn);
     * ```
     *
     * For all classes, the value of `scheme` is set as the value of both the `className` and `driver`
     * unless they have been otherwise specified.
     *
     * Note that query-string arguments are also parsed and set as values in the returned configuration.
     * Params:
     * string adsn The DSN string to convert to a configuration array
     */
static Json[string] parseDsn(string adsn) {
    configData = _parseDsn(dsn);

    if (configuration.hasKey("path") && configuration.get("database").isEmpty) {
        configuration.get("database", substr(configuration.get("path"), 1);}
        if (configuration.get("driver").isEmpty) {
            configuration.get("driver", configuration.get("className")); configuration.get("className", Connection
                    .classname);}
            unset(configuration.get("path"]); return configData;}

            /**
     * Set one or more connection aliases.
     *
     * Connection aliases allow you to rename active connections without overwriting
     * the aliased connection. This is most useful in the test-suite for replacing
     * connections with their test variant.
     *
     * Defined aliases will take precedence over normal connection names. For example,
     * if you alias "default" to 'test", fetching "default" will always return the 'test'
     * connection as long as the alias is defined.
     *
     * You can remove aliases with ConnectionManager.dropAlias().
     *
     * ### Usage
     *
     * ```
     * Make 'things' resolve to 'test_things' connection
     * ConnectionManager.alias("test_things", "things");
     * Params:
     * @param string aalias The alias name that resolves to `source`.
     */
    static void alias(string connectionAlias, string sourceAlias) {
        _connectionAliases[connectionAlias] = sourceAlias;
    }

    /**
     * Drop an alias.
     *
     * Removes an alias from ConnectionManager. Fetching the aliased
     * connection may fail if there is no other connection with that name.
     */
    static void dropAlias(string connectionAlias) {
        unset(_connectionAliases[connectionAlias]);
    }

    // Returns the current connection aliases and what they alias.
    static STRINGAA aliases() {
        return _connectionAliases;
    }

    /**
     * Get a connection.
     *
     * If the connection has not been constructed an instance will be added
     * to the registry. This method will use any aliases that have been
     * defined. If you want the original unaliased connections pass `false`
     * as second parameter.
     * Params:
     */
    static IConnection get(string connectionName, bool useAliases = true) {
        if (useAliases && isSet(_connectionAliases[connectionName])) {
            connectionName = _connectionAliases[connectionName];
        }
        if (!isSet(configuration.data(connectionName])) {
            throw new DMissingDatasourceConfigException(
                ["name": connectionName]); }

            _registry ? _registry : new DConnectionRegistry();
                return _registry. {
                    connectionName
                }
                ?  ? _registry.load(connectionName, configuration.data(
                connectionName]); 
    }*/
}
