/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.databases.classes.drivers.mysql;

import uim.databases;

@safe:
class DMysqlDriver : DDriver {
    mixin(DriverThis!("Mysql"));

    protected const MAX_ALIAS_LENGTH = 256;

    // Server type MySQL
    protected const string SERVER_TYPE_MYSQL = "mysql";

    // Server type MariaDB
    protected const string SERVER_TYPE_MARIADB = "mariadb";

    /**
     * Server type.
     *
     * If the underlying server is MariaDB, its value will get set to `'mariadb'`
     * after `currentVersion()` method is called.
     */
    protected string _serverType;

    // Mapping of feature to db server version for feature availability checks.
    protected Json[string] _featureVersions;

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        // Base configuration settings for MySQL driver
        configuration
            .merge("persistent", true)
            .merge("host", "localhost")
            .merge("username", "root")
            .merge("password", "")
            .merge("database", "uim")
            .merge("port", "3306")
            .merge("flags", Json.emptyArray)
            .merge("encoding", "utf8mb4")
            .merge("timezone", Json(null))
            .merge("init", Json.emptyArray);

        startQuote("`");
        endQuote("`");

        // Server type.
        _serverType = SERVER_TYPE_MYSQL;

        // Mapping of feature to db server version for feature availability checks.
        Json[string] mysql = createMap!(string, Json)
            .set("Json", "5.7.0")
            .set("cte", "8.0.0")
            .set("window", "8.0.0");

        Json[string] mariadb = createMap!(string, Json)
            .set("Json", "10.2.7")
            .set("cte", "10.2.1")
            .set("window", "10.2.0");

        _featureVersions
            .set("mysql", mysql)
            .set("mariadb", mariadb);

        return true;

    }

    bool supports(DriverFeatures feature) {
        switch (feature) {
        case DriverFeatures.DISABLE_CONSTRAINT_WITHOUT_TRANSACTION,
            DriverFeatures.SAVEPOINT:
            return true;

        case DriverFeatures.TRUNCATE_WITH_CONSTRAINTS:
            return false;

        case DriverFeatures.CTE,
            DriverFeatures.JSON,
            DriverFeatures.WINDOW: return false; // TODO
            /* return version_compare(
                this.currentVersion(),
                this.featureVersions[this.serverType][feature.value],
                ">="); */
        default:
            return false;
        }
    }

    // #region SQL
    // Get the SQL for disabling foreign keys.
    override string sqlDisableForeignKey() {
        return "SET foreign_key_checks = 0";
    }

    override string sqlEnableForeignKey() {
        return "SET foreign_key_checks = 1";
    }
    // #endregion 
    
    void connect() {
        // TODO
    }
}

mixin(DriverCalls!("Mysql"));

unittest {
    assert(MysqlDriver);
}
