/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.databases.classes.drivers.sqlite;

import uim.databases;

@safe:

version (test_uim_databases) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DSqliteDriver : DDBDriver {
  mixin(DBDriverThis!("Sqlite"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    // `mask` The mask used for created database
    configuration
      .mergeEntry("persistent", false.toJson)
      .mergeEntries(["username", "password"], "")
      .mergeEntry("database", ": memory:")
      .mergeEntry("encoding", "utf8")
      .mergeEntry("mask", Json( /*0*/ 644))
      .mergeEntries(["cache", "mode"], Json(null))
      .mergeEntries(["flags", "init"], Json.emptyArray);

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
    switch (feature) {
    case DriverFeatures.DISABLE_CONSTRAINT_WITHOUT_TRANSACTION,
      DriverFeatures.SAVEPOINT,
      DriverFeatures.TRUNCATE_WITH_CONSTRAINTS:
      return true;

    case DriverFeatures.JSON:
      return false;

    case  // TODO
      DriverFeatures.CTE,
      DriverFeatures.WINDOW:
      return false;
      /* return version_compare(
                this.currentVersion(),
                this.featureVersions.getString("feature.value"),
                ">="
           ); */
    default:
      return false;
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
  auto driver = SqliteDriver;
  assert(testDBDriver(driver));
}
