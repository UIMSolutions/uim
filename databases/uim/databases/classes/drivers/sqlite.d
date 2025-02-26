/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.databases.classes.drivers.sqlite;

import uim.databases;

@safe:

class DSqliteDriver : DDBDriver {
    mixin(DBDriverThis!("Sqlite"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        // `mask` The mask used for created database
        configuration
            .merge("persistent", false.toJson)  
            .merge("username", "")
            .merge("password", "")
            .merge("database", ": memory:")
            .merge("encoding", "utf8")
            .merge("mask", Json(/*0*/644))
            .merge("cache", Json(null))
            .merge("mode", Json(null))
            .merge("flags", Json.emptyArray)
            .merge("init", Json.emptyArray);

        startQuote("\"");
        endQuote("\"");

        return true;
    }

        // #region SQL
        // Get the SQL for disabling foreign keys.
        override string sqlDisableForeignKey() {
            return "PRAGMA foreign_keys = OFF";
        }

        override string sqlEnableForeignKey() {
            return "PRAGMA foreign_keys = ON";
        }
    // #endregion SQL

    bool supports(DriverFeatures feature) {
        switch(feature) {
            case 
            DriverFeatures.DISABLE_CONSTRAINT_WITHOUT_TRANSACTION,
            DriverFeatures.SAVEPOINT,
            DriverFeatures.TRUNCATE_WITH_CONSTRAINTS: return true;

            case
            DriverFeatures.JSON: return false;

            case // TODO
            DriverFeatures.CTE,
            DriverFeatures.WINDOW: return false; 
            /* return version_compare(
                this.currentVersion(),
                this.featureVersions.getString("feature.value"),
                ">="
           ); */
            default: return false;
        };
    }

    override IDBDriver connect() {
        super.connect();
        // TODO
        return this;
    }

    override IDBDriver disconnect() {
        super.disconnect();
        // TODO
        return this;
    }
}
mixin(DBDriverCalls!("Sqlite"));

unittest {
    assert(SqliteDriver);
}