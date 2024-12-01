module uim.databases.classes.drivers.postgres;

import uim.databases;

@safe:
class DPostgresDriver : DDriver {
    mixin(DriverThis!("Postgres"));

    // #region consts
    protected const MAX_ALIAS_LENGTH = 63;
    // #endregion consts

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration
            .setDefault("persistent", true)
            .setDefault("host", "localhost")
            .setDefault("username", "root")
            .setDefault("password", "")
            .setDefault("database", "uim")
            .setDefault("schema", "public")
            .setDefault("port", 5432)
            .setDefault("encoding", "utf8")
            .setDefault("timezone", Json(null))
            .setDefault("flags", Json.emptyArray)
            .setDefault("init", Json.emptyArray);

        // String used to start a database identifier quoting to make it safe
        startQuote("\"");
        endQuote("\"");

        return true;
    }

    bool supports(DriverFeatures feature) {
        switch(feature) {
            case
            DriverFeatures.CTE,
            DriverFeatures.JSON,
            DriverFeatures.SAVEPOINT,
            DriverFeatures.WINDOW : return true;

            case
            DriverFeatures.DISABLE_CONSTRAINT_WITHOUT_TRANSACTION : return false;

            default: return false;
        };
    }

    // #region SQL
        // Get the SQL for disabling foreign keys.
        override string sqlDisableForeignKey() {
            return "SET CONSTRAINTS ALL DEFERRED";
        }

        override string sqlEnableForeignKey() {
            return "SET CONSTRAINTS ALL IMMEDIATE";
        }
    // #endregion SQL

    void connect() {
        // TODO
    }
}
mixin(DriverCalls!("Postgres"));

unittest {
    assert(PostgresDriver);
}