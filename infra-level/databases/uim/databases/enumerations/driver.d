module uim.databases.enumerations.driver;

import uim.databases;
@safe:

version (test_uim_databases) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

enum DriverFeatures : string {
    // Default
    NONE = "none",

    // Common Table Expressions (with clause) support.
    CTE = "cte",

    // Disabling constraints without being in transaction support.
    DISABLE_CONSTRAINT_WITHOUT_TRANSACTION = "disable-constraint-without-transaction",

    // Native JSON data type support.
    JSON = "json",

    // PDO::quote() support.
    QUOTE = "quote",

    // Transaction savepoint support.
    SAVEPOINT = "savepoint",

    // Truncate with foreign keys attached support.
    TRUNCATE_WITH_CONSTRAINTS = "truncate-with-constraints",

    // Window function support (all or partial clauses).
    WINDOW = "window"
}

// #region convert
auto driverFeatures() {
    return [EnumMembers!DriverFeatures];
}

auto toStrings(DriverFeatures[] features) {
    return features.map!(f => cast(string)f).array;
}

auto driverFeatures(string name) {
    foreach(feature; driverFeatures) {
        if (cast(string)feature == name) return feature;
    }
    return DriverFeatures.NONE;
}
unittest {
    assert(driverFeatures("json") == DriverFeatures.JSON);
}
// #endregion convert
