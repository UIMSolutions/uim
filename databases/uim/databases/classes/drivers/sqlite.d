module uim.databases.classes.drivers.sqlite;

import uim.databases;

@safe:

class DSqliteDriver : DDriver {
    mixin(DriverThis!("Sqlite"));
    mixin TTupleComparisonTranslatorTemplate;

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        // `mask` The mask used for created database
        configuration.merge([
            "persistent": false.toJson,
            "username": "".toJson,
            "password": "".toJson,
            "database": Json(": memory:"),
            "encoding": Json("utf8"), 
            "mask": Json(/*0*/644),
            "cache": Json(null),
            "mode": Json(null),
            "flags": Json.emptyArray,
            "init": Json.emptyArray 
        ]);

        startQuote("\"");
        endQuote("\"");

        return true;
    }

    protected const STATEMENT_CLASS = SqliteStatement.classname;

    // Whether the connected server supports window functions
    protected bool _supportsWindowFunctions = null;
    
    // #region foreignKeySQL
        // Get the SQL for disabling foreign keys.
        override string disableForeignKeySQL() {
            return "PRAGMA foreign_keys = OFF";
        }

        override string enableForeignKeySQL() {
            return "PRAGMA foreign_keys = ON";
        }
    // #endregion foreignKeySQL



    // Mapping of date parts.
    protected STRINGAA _dateParts = [
        "day": "d",
        "hour": "H",
        "month": "m",
        "minute": "M",
        "second": "s",
        "week": "W",
        "year": "Y",
    ];

    // Mapping of feature to db server version for feature availability checks.
    protected STRINGAA featureVersions = [
        "cte": "3.8.3",
        "window": "3.28.0",
    ];

    void connect() {
        if (isSet(_pdo)) {
            return;
        }
        configData = configuration;
        configuration.update("flags", [
            PDO.ATTR_PERSISTENT: configuration.get("persistent"],
            PDO.ATTR_EMULATE_PREPARES: false,
            PDO.ATTR_ERRMODE: PDO.ERRMODE_EXCEPTION,
        ]);
        if (!configuration.isString("database") || configuration.getString("database") is null) {
            name = configData.get("name", "unknown");
            throw new DInvalidArgumentException(
                "The `database` key for the `{name}` SQLite connection needs to be a non-empty string."
           );
        }
        chmodFile = false;
        if (configuration.getString("database") != ": memory:" && configuration.getString("mode") != "memory") {
            chmodFile = !fileExists(configuration.get("database"));
        }
        
        string[] params = null;
        params ~= configuration.hasKey("cache") ? "cache=" ~ configuration.getString("cache") : null;
        params ~= configuration.hasKey("mode") ? "mode=" ~ configuration.getString("mode") : null;

        auto dsn = params 
            ? "sqlite:file:" ~ configuration.get("database") ~ "?" ~ params.join("&")
            : "sqlite:" ~ configuration.get("database"];
        }
        _pdo = createPdo(dsn, configData);
        if (chmodFile) {
            @chmod(configuration.get("database"), configuration.get("mask"]);
        }
        if (!(configuration.isEmpty("init")) {
            foreach (command; /* (array) */configuration.get("init"]) {
                _pdo.exec(command);
            }
        }
    }
    
    // Returns whether UIM is able to use this driver for connecting to database
    bool enabled() {
        return isIn("sqlite", PDO.getAvailableDrivers(), true);
    }
    
    bool supports(DriverFeatures feature) {
        return match (feature) {
            DriverFeatures.DISABLE_CONSTRAINT_WITHOUT_TRANSACTION,
            DriverFeatures.SAVEPOINT,
            DriverFeatures.TRUNCATE_WITH_CONSTRAINTS: true,

            DriverFeatures.Json: false,

            DriverFeatures.CTE,
            DriverFeatures.WINDOW: version_compare(
                this.currentVersion(),
                this.featureVersions[feature.value],
                '>='
           ),
        };
    }
 
    DSchemaDialect schemaDialect() {
        if (isSet(_schemaDialect)) {
            return _schemaDialect;
        }
        return _schemaDialect = new DSqliteSchemaDialect(this);
    }
 
    DQueryCompiler newCompiler() {
        return new DSqliteCompiler();
    }
 
    protected Json[string] _expressionTranslators() {
        return [
            FunctionExpression.classname: "_transformFunctionExpression",
            TupleComparison.classname: "_transformTupleComparison",
        ];
    }
    
    /**
     * Receives a FunctionExpression and changes it so that it conforms to this
     * SQL dialect.
     * Params:
     * \UIM\Database\Expression\FunctionExpression expression The auto expression to convert to TSQL.
     */
    protected void _transformFunctionExpression(DFunctionExpression expression) {
        switch (expression.name) {
            case "CONCAT": 
                // CONCAT bool is expressed as exp1 || exp2
                expression.name("").conjunctionType(" ||");
                break;
            case "DATEDIFF": 
                with(expression) {
                    name("ROUND");
                    conjunctionType("-");
                    iterateParts(function (p) {
                        return new DFunctionExpression("JULIANDAY", [p["value"]], [p["type"]]);
                    });
                }
                break;
            case "NOW": 
                expression.name("DATETIME").add(["'now'": "literal"]);
                break;
            case "RAND": 
                expression
                    .name("ABS")
                    .add(["RANDOM() % 1": "literal"], [], true);
                break;
            case "CURRENT_DATE": 
                expression.name("DATE").add(["'now'": "literal"]);
                break;
            case "CURRENT_TIME": 
                expression.name("TIME").add(["'now'": "literal"]);
                break;
            case "EXTRACT": 
                expression
                    .name("STRFTIME")
                    .conjunctionType(" ,")
                    .iterateParts(function (p, aKey) {
                        if (aKey == 0) {
                            aValue = stripRight(sp.lower, "s");
                            if (_dateParts.hasKey(aValue)) {
                                p = ["value": "%" ~ _dateParts[aValue], "type": Json(null)];
                            }
                        }
                        return p;
                    });
                break;
            case "DATE_ADD": 
                expression
                    .name("DATE")
                    .conjunctionType(",")
                    .iterateParts(function (p, aKey) {
                        if (aKey == 1) {
                            p = ["value": p, "type": Json(null)];
                        }
                        return p;
                    });
                break;
            case "DAYOFWEEK": 
                expression
                    .name("STRFTIME")
                    .conjunctionType(" ")
                    .add(["'%w", ": "literal"], [], true)
                    .add([") + (1": "literal"]); // Sqlite starts on index 0 but Sunday should be 1
                break;
        }
    } 
}
