module databases.uim.databases.enumerations.driver;

enum DriverFeatures : string {
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