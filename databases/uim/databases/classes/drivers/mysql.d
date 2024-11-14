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

        return true;
    }

    // #region SQL
    // Get the SQL for disabling foreign keys.
    override string sqlDisableForeignKey() {
        return "SET foreign_key_checks = 0";
    }

    override string sqlEnableForeignKey() {
        return "SET foreign_key_checks = 1";
    }
    // #endregion SQL
}

mixin(DriverCalls!("Mysql"));

unittest {
    assert(MysqlDriver);
}
