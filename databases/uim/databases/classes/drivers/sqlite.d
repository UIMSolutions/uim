/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.databases.classes.drivers.sqlite;

import uim.databases;

@safe:

class DSqliteDriver : DDriver {
    mixin(DriverThis!("Sqlite"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        // `mask` The mask used for created database
        configuration
            .merge("persistent", false.toJson)  
            .merge("username", "".toJson)
            .merge("password", "".toJson)
            .merge("database", Json(": memory:"))
            .merge("encoding", Json("utf8"),)
            .merge("mask", Json(/*0*/644))
            .merge("cache", Json(null))
            .merge("mode", Json(null))
            .merge("flags", Json.emptyArray)
            .merge("init", Json.emptyArray);

        startQuote("\"");
        endQuote("\"");

        return true;
    }

        // #region foreignKeySQL
        // Get the SQL for disabling foreign keys.
        override string sqlDisableForeignKey() {
            return "PRAGMA foreign_keys = OFF";
        }

        override string sqlEnableForeignKey() {
            return "PRAGMA foreign_keys = ON";
        }
    // #endregion foreignKeySQL
}
mixin(DriverCalls!("Sqlite"));

unittest {
    assert(SqliteDriver);
}