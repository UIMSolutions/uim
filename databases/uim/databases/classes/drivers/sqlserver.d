/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.databases.classes.drivers.sqlserver;

import uim.databases;
@safe:

version (test_uim_databases) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DSqlserverDriver : DDBDriver {
    mixin(DBDriverThis!("Sqlserver"));

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

mixin(DBDriverCalls!("Sqlserver"));

unittest {
    auto driver = SqlserverDriver;
    assert(testDBDriver(driver));
}
