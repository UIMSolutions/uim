/*********************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        *
*	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  *
*	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      *
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
     * The connection will not be constructed until it is first used.
     */
    static void setConfiguration(string[] key, /* IConnection | Closure */ Json[string] options = null) {
        configuration
            .set("name", key)
            .set(key, options);
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
     * dsn = "uim\databases.Driver\Mysql://localhost:3306/database?classname=uim\databases.Connection";
     * myConfiguration = ConnectionManager.parseDsn(dsn);
     *
     * dsn = "uim\databases.Connection://localhost:3306/database?driver=uim\databases.Driver\Mysql";
     * myConfiguration = ConnectionManager.parseDsn(dsn);
     * ```
     *
     * For all classes, the value of `scheme` is set as the value of both the `classname` and `driver`
     * unless they have been otherwise specified.
     *
     * Note that query-string arguments are also parsed and set as values in the returned configuration.
     */
    static Json[string] parseDsn(string dsnToConvert) {
        auto data = _parseDsn(dsnToConvert);

        if (data.hasKey("path") && data.isEmpty("database")) {
            data.set("database", subString(data.getString("path"), 1));
        }

        if (data.isEmpty("driver")) {
            data.set("driver", data.getString("classname"));
            data.set("classname", Connection.classname);
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
    static void aliasName(string sourceConnection, string aliasName) {
        _aliasMap.set(aliasName, sourceConnection);
    }

    /**
     * Drop an alias.
     *
     * Removes an alias from ConnectionManager. Fetching the aliased
     * connection may fail if there is no other connection with that name.
     */
    static void dropAlias(aliasToDrop) {
        remove(_aliasMap[aliasToDrop]);
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
        if (useAliases && _aliasMap.hasKey(connectionName)) {
            connectionName = _aliasMap[connectionName];
        }
        if (configuration.isEmpty(connectionName)) {
            throw new DMissingDatasourceConfigException(["name": connectionName]);
        }
        /** @psalm-suppress RedundantPropertyInitializationCheck  */
        if (_registry !is null) {
            _registry = new DConnectionRegistry();
        }

        // TODO 
        return null;
        /* 
    return _registry. {
        connectionName
    }
    
    ?  ? _registry.load(connectionName, configuration.get(connectionName)); */
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
     * dsn = "UIM\Database\Driver\Mysql://localhost:3306/database?classname=UIM\Database\Connection";
     * configData = ConnectionManager.parseDsn(dsn);
     *
     * dsn = "UIM\Database\Connection://localhost:3306/database?driver=UIM\Database\Driver\Mysql";
     * configData = ConnectionManager.parseDsn(dsn);
     * ```
     *
     * For all classes, the value of `scheme` is set as the value of both the `classname` and `driver`
     * unless they have been otherwise specified.
     *
     * Note that query-string arguments are also parsed and set as values in the returned configuration.
     */
    static Json[string] parseDsn(string dsn) {
        auto dsnData = _parseDsn(dsn);

        if (dsnData.hasKey("path") && dsnData.isEmpty("database")) {
            dsnData.set("database", subString(configuration.get("path"), 1));
        }
        if (dsnData.isEmpty("driver")) {
            dsnData.set("driver", dsnData.get("classname"));
            dsnData.set("classname", Connection.classname);
        }
        dsnData.remove("path");
        return configData;
    }

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
     */
    static void aliasName(string connectionAlias, string sourceAlias) {
        _connectionAliases[connectionAlias] = sourceAlias;
    }

    /**
     * Drop an alias.
     *
     * Removes an alias from ConnectionManager. Fetching the aliased
     * connection may fail if there is no other connection with that name.
     */
    static void dropAlias(string connectionAlias) {
        remove(_connectionAliases[connectionAlias]);
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
        if (useAliases && _connectionAliases.hasKey(connectionName)) {
            connectionName = _connectionAliases[connectionName];
        }
        if (!configuration.hasKey(connectionName)) {
            throw new DMissingDatasourceConfigException(["name": connectionName]);
        }
        // TODO
        return null;

        /* 
    _registry ? _registry : new DConnectionRegistry();
    return _registry. {
        connectionName
    } ?? _registry.load(connectionName, configuration.get(connectionName));
    */
    }
