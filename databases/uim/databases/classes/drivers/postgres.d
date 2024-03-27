module uim.databases.classes.drivers.postgres;

import uim.databases;

@safe:
class DPostgresDriver : DDriver {
    mixin(DriverThis!("Postgres"));

    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        /*    _baseConfig = [
            "persistent": true,
            "host": "localhost",
            "username": "root",
            "password": "",
            "database": "uim",
            "schema": "public",
            "port": 5432,
            "encoding": "utf8",
            "timezone": null,
            "flags": [],
            "init": [],
        ];
*/
        // String used to start a database identifier quoting to make it safe
        startQuote("\"");
        endQuote("\"");

        return true;
    }

    /** 
    protected const MAX_ALIAS_LENGTH = 63;

    void connect() {
        if (isSet(this.pdo)) {
            return;
        }

        auto configData = configuration;
        configuration["flags"].data([
            PDO.ATTR_PERSISTENT: configuration["persistent"],
            PDO.ATTR_EMULATE_PREPARES: false,
            PDO.ATTR_ERRMODE: PDO.ERRMODE_EXCEPTION,
        ]);

        string dsn = configuration["unix_socket"].isEmpty
            ? `pgsql:host={configuration["host"]};port={configuration["port"]};dbname={configuration["database"]}`
            : `pgsql:dbname={configuration["database"]}`;
    }

    this.pdo = this.createPdo(dsn, configData);
    if (!(configuration["encoding"].isEmpty) {
        this.setEncoding(configuration["encoding"]);
    }

    if (!configuration["schema"].isEmpty) {
        this.setSchema(configuration["schema"]);
    }
    if (!configuration["timezone"].isEmpty) {
        configuration["init"] ~= "SET timezone = %s".format(this.getPdo()
                .quote(configuration["timezone"]));
    }
    configuration["init"].each!(command => this.getPdo().exec(command));
}


override bool enabled() {
    return in_array("pgsql", PDO.getAvailableDrivers(), true);
}

SchemaDialect schemaDialect() {
    if (isSet(_schemaDialect)) {
        return _schemaDialect;
    }
    return _schemaDialect = new PostgresSchemaDialect(this);
}

// Sets connection encoding
void setEncoding(string encodingToUse) {
    auto myPdo = this.getPdo();
    myPdoo.exec("SET NAMES " ~ myPdo.quote(encodingToUseg));
}

/**
     * Sets connection default schema, if any relation defined in a query is not fully qualified
     * postgres will fallback to looking the relation into defined default schema
     * Params:
     * string aschema The schema names to set `search_path` to.
     * /
void setSchema(string aschema) {
    pdo = this.getPdo();
    pdo.exec("SET search_path TO " ~ pdo.quote(tableSchema));
}

// Get the SQL for disabling foreign keys.
string disableForeignKeySQL() {
    return "SET CONSTRAINTS ALL DEFERRED";
}

string enableForeignKeySQL() {
    return "SET CONSTRAINTS ALL IMMEDIATE";
}

bool supports(DriverFeaturesfeature) {
    return match(feature) {
        DriverFeatures.CTE,
        DriverFeatures.IData,
        DriverFeatures.SAVEPOINT,
        DriverFeatures.TRUNCATE_WITH_CONSTRAINTS,
        DriverFeatures.WINDOW
            : true,

            DriverFeatures.DISABLE_CONSTRAINT_WITHOUT_TRANSACTION : false,
    };
}

protected SelectQuery _transformDistinct(SelectQuery aQuery) {
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
        // use trim() to work around expression being transformed multiple times
        expressionToTranform.collation("\"" ~ trim(collation, "\"") ~ "\"");
    }
}

/**
     * Receives a FunctionExpression and changes it so that it conforms to this
     * SQL dialect.
     * Params:
     * \UIM\Database\Expression\FunctionExpression expression The auto expression to convert
     *  to postgres SQL.
     * /
protected void _transformFunctionExpression(FunctionExpression expressionToConvert) {
    switch (expressionToConvert.name) {
    case "CONCAT":
        // CONCAT bool is expressed as exp1 || exp2
        expressionToConvert.name("").setConjunction(" ||");
        break;
    case "DATEDIFF":
        expressionToConvert
            .name("")
            .setConjunction("-")
            .iterateParts(function(p) {
                if (isString(p)) {
                    p = ["value": [p: "literal"], "type": null];} else {
                        p["value"] = [p["value"]];}
                        return new FunctionExpression("DATE", p["value"], [p["type"]]);
                    }
);
                    break;
    case "CURRENT_DATE" : time = new FunctionExpression("LOCALTIMESTAMP", [" 0 ": "literal"]);
                    expressionToConvert.name("CAST").setConjunction(" AS ")
                        .add([time, "date": "literal"]);
                    break;
    case "CURRENT_TIME" : time = new FunctionExpression("LOCALTIMESTAMP", [" 0 ": "literal"]);
                    expressionToConvert.name("CAST").setConjunction(" AS ")
                        .add([time, "time": "literal"]);
                    break;
    case "NOW" : expressionToConvert.name("LOCALTIMESTAMP").add([" 0 ": "literal"]);
                    break;
    case "RAND" : expressionToConvert.name("RANDOM");
                    break;
    case "DATE_ADD" : expressionToConvert
                        .name("")
                        .setConjunction(" + INTERVAL")
                        .iterateParts(function(p, aKey) {
                            if (aKey == 1) {
                                p = "'%s'".format(p);}
                                return p;});
                                break;
    case "DAYOFWEEK" : expressionToConvert
                                .name("EXTRACT")
                                .setConjunction(" ")
                                .add(["DOW FROM": "literal"], [], true)
                                .add([") + (1": "literal"]); // Postgres starts on index 0 but Sunday should be 1
                                break;
                            }
                        }

                    // Changes string expression into postgresql format.
                    protected void _transformStringExpression(StringExpression expressionToTranform) {
                        // use trim() to work around expression being transformed multiple times
                        expressionToTranform.collation("\"" ~ trim(
                            expressionToTranform.collation(), "\"") ~ "\"");
                    }

                    QueryCompiler newCompiler() {
                        return new PostgresCompiler();
                    }
                } */
}
