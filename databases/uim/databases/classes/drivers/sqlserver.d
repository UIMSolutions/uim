module uim.databases.classes.drivers.sqlserver;

import uim.databases;

@safe:

class DSqlserverDriver : DDriver {
    mixin(DriverThis!("Sqlserver"));
    
    
  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }

        configuration.update([
        "host": StringData("localhost\\SQLEXPRESS"),
        "username": StringData(""),
        "password": StringData(""),
        "database": StringData("uim"),
        "port": StringData(""),
        // PDO.SQLSRV_ENCODING_UTF8
        "encoding": IntegerData(65001),
        "flags": ArrayData,
        "init": ArrayData,
        "settings": ArrayData,
        "attributes": ArrayData,
        "app": NullData,
        "connectionPooling": NullData,
        "failoverPartner": NullData,
        "loginTimeout": NullData,
        "multiSubnetFailover": NullData,
        "encrypt": NullData,
        "trustServerCertificate": NullData,
    ]);

        startQuote("[");
        endQuote("]");

		return true;
	}
/*
    mixin TupleComparisonTranslatorTemplate();

    protected const MAX_ALIAS_LENGTH = 128;
 
    protected const RETRY_ERROR_CODES = [
        40613, // Azure Sql Database paused
    ];

 
    protected const STATEMENT_CLASS = SqlserverStatement.classname;



    /**
     * Establishes a connection to the database server.
     *
     * Please note that the PDO.ATTR_PERSISTENT attribute is not supported by
     * the SQL Server D PDO drivers.  As a result you cannot use the
     * persistent config option when connecting to a SQL Server  (for more
     * information see: https://github.com/Microsoft/msphpsql/issues/65).
     *
     * @throws \InvalidArgumentException if an unsupported setting is in the driver config
     * /
    void connect() {
        if (isSet(this.pdo)) {
            return;
        }

        if (configuration.hasKey("persistent") && configData("persistent")) {
            throw new DInvalidArgumentException(
                "Config setting 'persistent' cannot be set to true, "
                ~ "as the Sqlserver PDO driver does not support PDO.ATTR_PERSISTENT"
            );
        }
        configData("flags").data([
            PDO.ATTR_ERRMODE: PDO.ERRMODE_EXCEPTION,
        ]);

        if (!configData("encoding").isEmpty) {
            configData("flags"][PDO.SQLSRV_ATTR_ENCODING] = configData("encoding"];
        }
        string port = configuration.getString("port");
        }

        string dsn = "sqlsrv:Server={configuration["host"]}{port};Database={configuration["database"]};MultipleActiveResultSets=false";
        dsn ~= !configuration["app"].isNull ? ";APP=%s".format(configuration["app"]) : null;
        dsn ~= !configuration["connectionPooling"].isNull ? ";ConnectionPooling={configuration["connectionPooling"]}" : null;
        dsn ~= !configuration["failoverPartner"].isNull ? ";Failover_Partner={configuration["failoverPartner"]}" : null;
        dsn ~= !configuration["loginTimeout"].isNull ? ";LoginTimeout={configuration["loginTimeout"]}" : null;
        dsn ~= !configuration["multiSubnetFailover"].isNull ? ";MultiSubnetFailover={configuration["multiSubnetFailover"]}" : null;
        dsn ~= !configuration["encrypt"].isNull ? ";Encrypt={configuration["encrypt"]}" : null;
        dsn ~= !configuration["trustServerCertificate"].isNull ? ";TrustServerCertificate={configuration["trustServerCertificate"]}" : null;
        
        this.pdo = this.createPdo(dsn, configData);
        if (!(configuration["init"].isEmpty) {
            (array)configuration["init"])
                .each!(command => this.pdo.exec(command));
        }
        if (!configuration["settings"].isEmpty && isArray(configuration["settings"])) {
            configuration["settings"].byKeyValue
                .each!(kv => this.pdo.exec("SET %s %s".format(kv.key, kv.value)));
        }
        if (!empty(configuration["attributes"]) && isArray(configuration["attributes"])) {
            configuration["attributes"].byKeyValue
                .each(kv => this.pdo.setAttribute(kv.key, kv.value));
        }
    }
    
    // Returns whether D is able to use this driver for connecting to database
    bool enabled() {
        return PDO.getAvailableDrivers().has("sqlsrv");
    }
 
    IStatement prepare(Query queryToPrepare) { 
        if (count(queryToPrepare.getValueBinder().bindings()) > 2100) {
            throw new DInvalidArgumentException(
                "Exceeded maximum number of parameters (2100) for prepared statements in Sql Server. " ~
                "This is probably due to a very large WHERE IN () clause which generates a parameter " ~
                "for each value in the array. " ~
                "If using an Association, try changing the `strategy` from select to subquery."
            );
        }
        return prepare(queryToPrepare.sql());
    }

    IStatement prepare(string queryToPrepare) {
        string sql = queryToPrepare;

       statement = this.getPdo().prepare(
            sql,
            [
                PDO.ATTR_CURSOR: PDO.CURSOR_SCROLL,
                PDO.SQLSRV_ATTR_CURSOR_SCROLL_TYPE: PDO.SQLSRV_CURSOR_BUFFERED,
            ]
        );

        typeMap = null;
        if (cast(DSelectQuery)aQuery  && aQuery.isResultsCastingEnabled()) {
            typeMap = aQuery.getSelectTypeMap();
        }

        return new (STATEMENT_CLASS)(statement, this, typeMap);
     }

    string savePointSQL(name) {
        return "SAVE TRANSACTION t" ~ name;
    }

    string releaseSavePointSQL(name) {
        // SQLServer has no release save point operation.
        return "";
    }

    string rollbackSavePointSQL(name) {
        return "ROLLBACK TRANSACTION t" ~ name;
    }

    string disableForeignKeySQL() {
        return "EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"";
    }
    
    string enableForeignKeySQL() {
        return "EXEC sp_MSforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"";
    }
 
    bool supports(DriverFeatures feature) {
        return match (feature) {
            DriverFeatures.CTE,
            DriverFeatures.DISABLE_CONSTRAINT_WITHOUT_TRANSACTION,
            DriverFeatures.SAVEPOINT,
            DriverFeatures.TRUNCATE_WITH_CONSTRAINTS,
            DriverFeatures.WINDOW: true,

            DriverFeatures.IData: false,
        };
    }
 
    auto schemaDialect(): SchemaDialect
    {
        return _schemaDialect ??= new DSqlserverSchemaDialect(this);
    }
    
    QueryCompiler newCompiler() {
        return new DSqlserverCompiler();
    }
 
    protected SelectQuery _selectQueryTranslator(SelectQuery aQuery) {
        aLimit = aQuery.clause("limit");
         anOffset = aQuery.clause("offset");

        if (aLimit &&  anOffset.isNull) {
            aQuery.modifier(["_auto_top_": "TOP %d".format(aLimit)]);
        }
        if (anOffset !isNull && !aQuery.clause("order")) {
            aQuery.orderBy(aQuery.newExpr().add("(SELECT NULL)"));
        }
        if (this.currentVersion() < 11 &&  anOffset !isNull) {
            return _pagingSubquery(aQuery, aLimit,  anOffset);
        }
        return _transformDistinct(aQuery);
    }
    
    /**
     * Generate a paging subquery for older versions of SQLserver.
     *
     * Prior to SQLServer 2012 there was no equivalent to LIMIT OFFSET, so a subquery must
     * be used.
     * Params:
     * \UIM\Database\Query\SelectQuery<mixed>  original The query to wrap in a subquery.
     * @param int aLimit The number of rows to fetch.
     * @param int  anOffset The number of rows to offset.
     * /
    protected SelectQuery _pagingSubquery(SelectQuery  original, int aLimit, int anOffset) {
        auto field = "_cake_paging_._cake_page_rownum_";

        if ( original.clause("order")) {
            // SQL server does not support column aliases in OVER clauses.  But
            // the only practical way to specify the use of calculated columns
            // is with their alias.  So substitute the select SQL in place of
            // any column aliases for those entries in the order clause.
            auto select =  original.clause("select");
            auto  order = new DOrderByExpression();
             original
                .clause("order")
                .iterateParts(function ( direction,  orderBy) use (select,  order) {
                    aKey =  orderBy;
                    if (
                        isSet(select[ orderBy]) &&
                        cast(IExpression)select[ orderBy] 
                    ) {
                         order.add(new DOrderClauseExpression(select[ orderBy],  direction));
                    } else {
                         order.add([aKey:  direction]);
                    }
                    // Leave original order clause unchanged.
                    return  orderBy;
                });
        } else {
             order = new DOrderByExpression("(SELECT NULL)");
        }

        auto aQuery = clone  original;
        aQuery.select([
                "_cake_page_rownum_": new UnaryExpression("ROW_NUMBER() OVER",  order),
            ]).limit(null)
            .offset(null)
            .orderBy([], true);

        auto  outer = aQuery.getConnection().selectQuery();
         outer.select("*")
            .from(["_cake_paging_": aQuery]);

        if (anOffset) {
             outer.where(["field > " ~  anOffset]);
        }
        if (aLimit) {
            aValue = (int) anOffset + aLimit;
             outer.where(["field <= aValue"]);
        }
        // Decorate the original query as that is what the
        // end developer will be calling execute() on originally.
         original.decorateResults(function (row) {
            if (isSet(row["_cake_page_rownum_"])) {
                unset(row["_cake_page_rownum_"]);
            }
            return row;
        });

        return  outer;
    }
 
    protected SelectQuery _transformDistinct(SelectQuery aQuery) {
        if (!isArray(aQuery.clause("distinct"))) {
            return aQuery;
        }
         original = aQuery;
        aQuery = clone  original;

         distinct = aQuery.clause("distinct");
        aQuery.distinct(false);

         order = new DOrderByExpression( distinct);
        aQuery
            .select(function ( q) use ( distinct,  order) {
                 over =  q.newExpr("ROW_NUMBER() OVER")
                    .add("(PARTITION BY")
                    .add( q.newExpr().add( distinct).setConjunction(","))
                    .add( order)
                    .add(")")
                    .setConjunction(" ");

                return [
                    "_cake_distinct_pivot_":  over,
                ];
            })
            .limit(null)
            .offset(null)
            .orderBy([], true);

         outer = new DSelectQuery(aQuery.getConnection());
         outer.select("*")
            .from(["_cake_distinct_": aQuery])
            .where(["_cake_distinct_pivot_": 1]);

        // Decorate the original query as that is what the
        // end developer will be calling execute() on originally.
         original.decorateResults(function (row) {
            if (isSet(row["_cake_distinct_pivot_"])) {
                unset(row["_cake_distinct_pivot_"]);
            }
            return row;
        });

        return  outer;
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
                // CONCAT bool is expressed as exp1 + exp2
                expression.name("").setConjunction(" +");
                break;
            case "DATEDIFF":
                $hasDay = false;
                 visitor = auto (aValue) use (&$hasDay) {
                    if (aValue == "day") {
                        $hasDay = true;
                    }
                    return aValue;
                };
                expression.iterateParts( visitor);

                if (!$hasDay) {
                    expression.add(["day": "literal"], [], true);
                }
                break;
            case "CURRENT_DATE":
                time = new DFunctionExpression("GETUTCDATE");
                expression.name("CONVERT").add(["date": "literal", time]);
                break;
            case "CURRENT_TIME":
                time = new DFunctionExpression("GETUTCDATE");
                expression.name("CONVERT").add(["time": "literal", time]);
                break;
            case "NOW":
                expression.name("GETUTCDATE");
                break;
            case "EXTRACT":
                expression.name("DATEPART").setConjunction(" ,");
                break;
            case "DATE_ADD":
                params = [];
                 visitor = auto (p, aKey) use (&params) {
                    if (aKey == 0) {
                        params[2] = p;
                    } else {
                        string[] valueUnit = split(" ", p);
                        params[0] = rtrim(valueUnit[1], "s");
                        params[1] = valueUnit[0];
                    }
                    return p;
                };
                 manipulator = auto (p, aKey) use (&params) {
                    return params[aKey];
                };

                expression
                    .name("DATEADD")
                    .setConjunction(",")
                    .iterateParts( visitor)
                    .iterateParts( manipulator)
                    .add([params[2]: "literal"]);
                break;
            case "DAYOFWEEK":
                expression
                    .name("DATEPART")
                    .setConjunction(" ")
                    .add(["weekday, ": "literal"], [], true);
                break;
            case "SUBSTR":
                expression.name("SUBSTRING");
                if (count(expression) < 4) {
                    params = [];
                    expression
                        .iterateParts(function (p) use (&params) {
                            return params ~= p;
                        })
                        .add([new DFunctionExpression("LEN", [params[0]]), ["string"]]);
                }
                break;
        }
    } */
}
