/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.databases.classes.drivers.sqlserver;

import uim.databases;

@safe:
class DSqlserverDriver : DDriver {
    mixin(DriverThis!("Sqlserver"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration
            .merge("host", "localhost\\SQLEXPRESS")
            .merge("username", "")
            .merge("password", "")
            .merge("database", "uim")
            .merge("port", "") // PDO.SQLSRV_ENCODING_UTF8
            .merge("encoding", 65_001)
            .merge(
                ["flags", "init", "settings", "attributes"], Json.emptyArray
            )
            .merge(
                [
                "app", "connectionPooling", "failoverPartner", "loginTimeout",
                "multiSubnetFailover", "encrypt", "trustServerCertificate"
            ],
            Json(null));

        startQuote("[");
        endQuote("]");

        return true;
    }

    protected const MAX_ALIAS_LENGTH = 128;

    string sqlRollbackSavePoint(string name) {
        return "ROLLBACK TRANSACTION t" ~ name;
    }

    override string sqlDisableForeignKey() {
        return "EXEC sp_MSforeachtable \"ALTER TABLE ? NOCHECK CONSTRAINT all\"";
    }

    override string sqlEnableForeignKey() {
        return "EXEC sp_MSforeachtable \"ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all\"";
    }

    string sqlSavePoint(string name) {
        return "SAVE TRANSACTION t" ~ name;
    }
}

mixin(DriverCalls!("Sqlserver"));

unittest {
    assert(SqlserverDriver);
}
