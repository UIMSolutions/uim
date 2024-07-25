module uim.databases.classes.drivers.postgres;

import uim.databases;

@safe:
class DPostgresDriver : DDriver {
    mixin(DriverThis!("Postgres"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration.updateDefaults([
            "persistent": true.toJson,
            "host": Json("localhost"),
            "username": Json("root"),
            "password": "".toJson,
            "database": Json("uim"),
            "schema": Json("public"),
            "port": Json(5432),
            "encoding": Json("utf8"),
            "timezone": Json(null),
            "flags": Json.emptyArray,
            "init": Json.emptyArray,
        ]);

        // String used to start a database identifier quoting to make it safe
        startQuote("\"");
        endQuote("\"");

        return true;
    }

    // #region consts
    protected const MAX_ALIAS_LENGTH = 63;
    // #endregion consts

    /** 
    void connect() {
        if (this.pdo !is null) {
            return;
        }

        auto configData = configuration;
        configuration.get("flags"].data([
            PDO.ATTR_PERSISTENT: configuration.get("persistent"],
            PDO.ATTR_EMULATE_PREPARES: false,
            PDO.ATTR_ERRMODE: PDO.ERRMODE_EXCEPTION,
        ]);

        string dsn = configuration.isEmpty("unix_socket")
            ? "pgsql:host={configuration.get("host"]};port={configuration.get("port"]};dbname={configuration.get("database"]}""
            : "pgsql:dbname={configuration.get("database"]}"";
    }

    _pdo = this.createPdo(dsn, configData);
    if (!(configuration.isEmpty("encoding")) {
        setEncoding(configuration.get("encoding"));
    }

    if (!configuration.isEmpty("schema")) {
        setSchema(configuration.get("schema"));
    }
    if (!configuration.isEmpty("timezone")) {
        configuration.get("init"] ~= "SET timezone = %s".format(getPdo().quote(configuration.get("timezone")));
    }
    configuration.get("init").each!(command => getPdo().exec(command));
}


override bool enabled() {
    return "pgsql".isIn(PDO.getAvailableDrivers();
}

SchemaDialect schemaDialect() {
    if (_schemaDialect is null) {
        _schemaDialect = new DPostgresSchemaDialect(this);
    }
    return _schemaDialect;
}

// Sets connection encoding
void setEncoding(string encodingToUse) {
    getPdo().exec("SET NAMES " ~ myPdo.quote(encodingToUseg));
}

/**
     * Sets connection default schema, if any relation defined in a query is not fully qualified
     * postgres will fallback to looking the relation into defined default schema
     * Params:
     * string aschema The schema names to set `search_path` to.
     */
    void setSchema(string aschema) {
        auto pdo = getPdo();
        pdo.exec("SET search_path TO " ~ pdo.quote(tableSchema));
    }

    // #region foreignKeySQL
        // Get the SQL for disabling foreign keys.
        override string disableForeignKeySQL() {
            return "SET CONSTRAINTS ALL DEFERRED";
        }

        override string enableForeignKeySQL() {
            return "SET CONSTRAINTS ALL IMMEDIATE";
        }
    // #endregion foreignKeySQL

    bool supports(DriverFeaturesfeature) {
        return match(feature) {
            DriverFeatures.CTE,
            DriverFeatures.Json,
            DriverFeatures.SAVEPOINT,
            DriverFeatures.TRUNCATE_WITH_CONSTRAINTS,
            DriverFeatures.WINDOW : true,

            DriverFeatures.DISABLE_CONSTRAINT_WITHOUT_TRANSACTION : false,
        };
    }

    protected ISelectQuery _transformDistinct(SelectQuery aQuery) {
        return aQuery;
    }

    protected InsertQuery _insertQueryTranslator(InsertQuery aQuery) {
        if (!aQuery.clause("epilog")) {
            aQuery.epilog("RETURNING *");
        }
        return aQuery;
    }

    protected STRINGAA _expressionTranslators() {
        return [
            IdentifierExpression.classname: "_transformIdentifierExpression",
            FunctionExpression.classname: "_transformFunctionExpression",
            StringExpression.classname: "_transformStringExpression",
        ];
    }

    // Changes identifer expression into postgresql format.
    protected void _transformIdentifierExpression(IdentifierExpression expressionToTranform) {
        auto collation = expressionToTranform.collation();
        if (collation) {
            // use strip() to work around expression being transformed multiple times
            expressionToTranform.collation("\"" ~ collation.strip("\"") ~ "\"");
        }
    }

    // Receives a FunctionExpression and changes it so that it conforms to this SQL dialect.
    protected void _transformFunctionExpression(FunctionExpression expressionToConvert) {
        switch (expressionToConvert.name) {
        case "CONCAT":
            // CONCAT bool is expressed as exp1 || exp2
            expressionToConvert.name("").conjunctionType(" ||");
            break;
        case "DATEDIFF":
            expressionToConvert
                .name("")
                .conjunctionType("-")
                .iterateParts(function(p) {
                    if (isString(p)) {
                        p = ["value": [p: "literal"], "type": Json(null)];
                    } else {
                        p["value"] = [p["value"]];
                    }
                    return new DFunctionExpression("DATE", p["value"], [
                            p["type"]
                        ]);
                }
               );
            break;
        case "CURRENT_DATE":
            auto time = new DFunctionExpression("LOCALTIMESTAMP", [" 0 ": "literal"]);
            expressionToConvert.name("CAST").conjunctionType(" AS ")
                .add(time, ["date": "literal"]);
            break;
        case "CURRENT_TIME":
            auto time = new DFunctionExpression("LOCALTIMESTAMP", [" 0 ": "literal"]);
            // TODO expressionToConvert.name("CAST").conjunctionType(" AS ").add(time, ["time": "literal"]);
            break;
        case "NOW":
            expressionToConvert.name("LOCALTIMESTAMP").add([" 0 ": "literal"]);
            break;
        case "RAND":
            expressionToConvert.name("RANDOM");
            break;
        case "DATE_ADD":
            expressionToConvert
                .name("")
                .conjunctionType(" + INTERVAL")
                .iterateParts(function(p, aKey) {
                    if (aKey == 1) {
                        p = "'%s'".format(p);
                    }
                    return p;
                });
            break;
        case "DAYOFWEEK":
            expressionToConvert
                .name("EXTRACT")
                .conjunctionType(" ")
                .add(["DOW FROM": "literal"], [], true)
                .add([") + (1": "literal"]); // Postgres starts on index 0 but Sunday should be 1
            break;
        }
    }

    // Changes string expression into postgresql format.
    protected void _transformStringExpression(StringExpression expressionToTranform) {
        // use strip() to work around expression being transformed multiple times
        expressionToTranform.collation("\"" ~ 
                expressionToTranform.collation().strip("\"") ~ "\"");
    }

    QueryCompiler newCompiler() {
        return new DPostgresCompiler();
    }
}

