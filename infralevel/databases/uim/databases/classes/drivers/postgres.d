module uim.databases.classes.drivers.postgres;

import uim.databases;
@safe:

version (test_uim_databases) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DPostgresDriver : DDBDriver {
    mixin(DBDriverThis!("Postgres"));

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
        switch (feature) {
        case DriverFeatures.CTE,
            DriverFeatures.JSON,
            DriverFeatures.SAVEPOINT,
            DriverFeatures.WINDOW:
            return true;

        case DriverFeatures.DISABLE_CONSTRAINT_WITHOUT_TRANSACTION:
            return false;

        default:
            return false;
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

    override IDBDriver connect() {
        super.connect();

/*         string connectUrl;
        connectUrl ~= configuration.getString("host") // ex. "localhost"
        configuration.getString("username", "root")
            .setDefault("password", "")
            .setDefault("database", "uim")
        string connectUrl = "postgresql://localhost:{port}/ddbctestdb?user={username},password={password},ssl=true";
 */        return this;
    }

    override IDBDriver disconnect() {
        super.disconnect();
        // TODO
        return this;
    }
}

mixin(DBDriverCalls!("Postgres"));

unittest {
    auto driver = PostgresDriver;
    assert(testDBDriver(driver));
}
