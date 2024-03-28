module uim.databases.classes.drivers.sqlite;

import uim.databases;

@safe:

class DSqliteDriver : DDriver {
    mixin(DriverThis!("Sqlite"));

    override bool initialize(IData[string] initData = null) {
        IData[string] baseData = [
            "persistent": BooleanData(false),
            "username": StringData,
            "password": StringData,
            "database": StringData(":memory:"),
            "encoding": StringData("utf8"),
            /* "mask": 0644,
            "cache": null,
            "mode": null,
            "flags": ArrayData,
            "init": ArrayData, */
        ];

        if (!super.initialize(baseData)) {
            return false;
        }

        updateConfiguration(initData);

        startQuote("\"");
        endQuote("\"");

        return true;
    }

    // Get the SQL for disabling foreign keys.
    string disableForeignKeySQL() {
        return "PRAGMA foreign_keys = OFF";
    }

    string enableForeignKeySQL() {
        return "PRAGMA foreign_keys = ON";
    }

    /*
    use TupleComparisonTranslatorTrait;

    protected const STATEMENT_CLASS = SqliteStatement.classname;

    /**
     * Base configuration settings for Sqlite driver
     *
     * - `mask` The mask used for created database
     * /

    // Whether the connected server supports window functions
    protected bool _supportsWindowFunctions = null;

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
        if (isSet(this.pdo)) {
            return;
        }
        configData = configuration;
        configuration["flags"] += [
            PDO.ATTR_PERSISTENT: configuration["persistent"],
            PDO.ATTR_EMULATE_PREPARES: false,
            PDO.ATTR_ERRMODE: PDO.ERRMODE_EXCEPTION,
        ];
        if (!configuration["database"].isString) || configuration["database"] == "") {
            name = configData.get("name", "unknown");
            throw new DInvalidArgumentException(
                "The `database` key for the `{name}` SQLite connection needs to be a non-empty string."
            );
        }
        chmodFile = false;
        if (configuration["database"] != ":memory:" && configuration["mode"] != "memory") {
            chmodFile = !file_exists(configuration["database"]);
        }
        
        string[] params = [];
        if (configuration["cache"]) {
            params ~= "cache=" ~ configuration["cache"];
        }
        if (configuration["mode"]) {
            params ~= "mode=" ~ configuration["mode"];
        }
        auto dsn = params 
            ? "sqlite:file:" ~ configuration["database"] ~ "?" ~ params.join("&")
            : "sqlite:" ~ configuration["database"];
        }
        this.pdo = this.createPdo(dsn, configData);
        if (chmodFile) {
            @chmod(configuration["database"], configuration["mask"]);
        }
        if (!(configuration["init"].isEmpty) {
            foreach ( command; (array)configuration["init"] ) {
                this.pdo.exec(command);
            }
        }
    }
    
    /**
     * Returns whether D is able to use this driver for connecting to database
     * /
    bool enabled() {
        return in_array("sqlite", PDO.getAvailableDrivers(), true);
    }
    


    bool supports(DriverFeatures feature) {
        return match (feature) {
            DriverFeatures.DISABLE_CONSTRAINT_WITHOUT_TRANSACTION,
            DriverFeatures.SAVEPOINT,
            DriverFeatures.TRUNCATE_WITH_CONSTRAINTS: true,

            DriverFeatures.IData: false,

            DriverFeatures.CTE,
            DriverFeatures.WINDOW: version_compare(
                this.currentVersion(),
                this.featureVersions[feature.value],
                '>='
            ),
        };
    }
 
    SchemaDialect schemaDialect() {
        if (isSet(_schemaDialect)) {
            return _schemaDialect;
        }
        return _schemaDialect = new DSqliteSchemaDialect(this);
    }
 
    QueryCompiler newCompiler() {
        return new DSqliteCompiler();
    }
 
    protected array _expressionTranslators() {
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
     * /
    protected void _transformFunctionExpression(FunctionExpression expression) {
        switch (expression.name) {
            case "CONCAT":
                // CONCAT bool is expressed as exp1 || exp2
                expression.name("").setConjunction(" ||");
                break;
            case "DATEDIFF":
                with(expression) {
                    name("ROUND");
                    setConjunction("-");
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
                    .setConjunction(" ,")
                    .iterateParts(function (p, aKey) {
                        if (aKey == 0) {
                            aValue = rtrim(sp.toLower, "s");
                            if (isSet(_dateParts[aValue])) {
                                p = ["value": '%" ~ _dateParts[aValue], "type": null];
                            }
                        }
                        return p;
                    });
                break;
            case "DATE_ADD":
                expression
                    .name("DATE")
                    .setConjunction(",")
                    .iterateParts(function (p, aKey) {
                        if (aKey == 1) {
                            p = ["value": p, "type": null];
                        }
                        return p;
                    });
                break;
            case "DAYOFWEEK":
                expression
                    .name("STRFTIME")
                    .setConjunction(" ")
                    .add(["'%w", ": 'literal"], [], true)
                    .add([") + (1": 'literal"]); // Sqlite starts on index 0 but Sunday should be 1
                break;
        }
    } */
}
