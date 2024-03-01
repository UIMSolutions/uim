module source.uim.databases.classes.drivers.sqlitex;

import uim.databases;

@safe:

class SqliteDriver : Driver {
    mixin(DriverThis!("SqliteDriver"));
    
  	override bool initialize(IConfigData[string] configData = null) {
		if (!super.initialize(configData)) { return false; }

        _baseConfig.data([
        "persistent": false,
        "username": null,
        "password": null,
        "database": ":memory:",
        "encoding": "utf8",
        "mask": 0644,
        "cache": null,
        "mode": null,
        "flags": [],
        "init": [],
    ]);

    protected string _startQuote = "\"";

    protected string _endQuote = "\"";
		return true;
	}

    use TupleComparisonTranslatorTrait;

    protected const STATEMENT_CLASS = SqliteStatement.classname;

    /**
     * Base configuration settings for Sqlite driver
     *
     * - `mask` The mask used for created database
     */

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
        configData = _config;
        configData["flags"] += [
            PDO.ATTR_PERSISTENT: configData["persistent"],
            PDO.ATTR_EMULATE_PREPARES: false,
            PDO.ATTR_ERRMODE: PDO.ERRMODE_EXCEPTION,
        ];
        if (!configData["database"].isString) || configData["database"] == "") {
            name = configData["name"] ?? "unknown";
            throw new InvalidArgumentException(
                "The `database` key for the `{name}` SQLite connection needs to be a non-empty string."
            );
        }
        $chmodFile = false;
        if (configData["database"] != ":memory:" && configData["mode"] != "memory") {
            $chmodFile = !file_exists(configData["database"]);
        }
        
        string[] params = [];
        if (configData["cache"]) {
            params ~= "cache=" ~ configData["cache"];
        }
        if (configData["mode"]) {
            params ~= "mode=" ~ configData["mode"];
        }
        auto dsn = params 
            ? "sqlite:file:" ~ configData["database"] ~ "?" ~ params.join("&")
            : "sqlite:" ~ configData["database"];
        }
        this.pdo = this.createPdo(dsn, configData);
        if ($chmodFile) {
            @chmod(configData["database"], configData["mask"]);
        }
        if (!empty(configData["init"])) {
            foreach ( $command; (array)configData["init"] ) {
                this.pdo.exec($command);
            }
        }
    }
    
    /**
     * Returns whether D is able to use this driver for connecting to database
     */
    bool enabled() {
        return in_array("sqlite", PDO.getAvailableDrivers(), true);
    }
    
    /**
     * Get the SQL for disabling foreign keys.
     */
    string disableForeignKeySQL() {
        return "PRAGMA foreign_keys = OFF";
    }
    string enableForeignKeySQL() {
        return "PRAGMA foreign_keys = ON";
    }

    bool supports(DriverFeatures feature) {
        return match (feature) {
            DriverFeatures.DISABLE_CONSTRAINT_WITHOUT_TRANSACTION,
            DriverFeatures.SAVEPOINT,
            DriverFeatures.TRUNCATE_WITH_CONSTRAINTS: true,

            DriverFeatures.JSON: false,

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
        return _schemaDialect = new SqliteSchemaDialect(this);
    }
 
    QueryCompiler newCompiler() {
        return new SqliteCompiler();
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
     * \UIM\Database\Expression\FunctionExpression $expression The auto expression to convert to TSQL.
     */
    protected void _transformFunctionExpression(FunctionExpression $expression) {
        switch ($expression.name) {
            case "CONCAT":
                // CONCAT bool is expressed as exp1 || exp2
                $expression.name("").setConjunction(" ||");
                break;
            case "DATEDIFF":
                $expression
                    .name("ROUND")
                    .setConjunction("-")
                    .iterateParts(function ($p) {
                        return new FunctionExpression("JULIANDAY", [$p["value"]], [$p["type"]]);
                    });
                break;
            case "NOW":
                $expression.name("DATETIME").add(["'now'": "literal"]);
                break;
            case "RAND":
                $expression
                    .name("ABS")
                    .add(["RANDOM() % 1": "literal"], [], true);
                break;
            case "CURRENT_DATE":
                $expression.name("DATE").add(["'now'": "literal"]);
                break;
            case "CURRENT_TIME":
                $expression.name("TIME").add(["'now'": "literal"]);
                break;
            case "EXTRACT":
                $expression
                    .name("STRFTIME")
                    .setConjunction(" ,")
                    .iterateParts(function ($p, aKey) {
                        if (aKey == 0) {
                            aValue = rtrim(s$p.toLower, "s");
                            if (isSet(_dateParts[aValue])) {
                                $p = ["value": '%" ~ _dateParts[aValue], "type": null];
                            }
                        }
                        return $p;
                    });
                break;
            case "DATE_ADD":
                $expression
                    .name("DATE")
                    .setConjunction(",")
                    .iterateParts(function ($p, aKey) {
                        if (aKey == 1) {
                            $p = ["value": $p, "type": null];
                        }
                        return $p;
                    });
                break;
            case "DAYOFWEEK":
                $expression
                    .name("STRFTIME")
                    .setConjunction(" ")
                    .add(["'%w", ": 'literal"], [], true)
                    .add([") + (1": 'literal"]); // Sqlite starts on index 0 but Sunday should be 1
                break;
        }
    }
}
