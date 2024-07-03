module uim.databases.classes.drivers.sqlserver;

import uim.databases;

@safe:

class DSqlserverDriver : DDriver {
    mixin TTupleComparisonTranslator;
    mixin(DriverThis!("Sqlserver"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration.update([
            "host": Json("localhost\\SQLEXPRESS"),
            "username": "".toJson,
            "password": "".toJson,
            "database": Json("uim"),
            "port": "".toJson,
            // PDO.SQLSRV_ENCODING_UTF8
            "encoding": Json(65_001),
            "flags": Json.emptyArray,
            "init": Json.emptyArray,
            "settings": Json.emptyArray,
            "attributes": Json.emptyArray,
            "app": Json(null),
            "connectionPooling": Json(null),
            "failoverPartner": Json(null),
            "loginTimeout": Json(null),
            "multiSubnetFailover": Json(null),
            "encrypt": Json(null),
            "trustServerCertificate": Json(null),
        ]);

        startQuote("[");
        endQuote("]");

        return true;
    }

protected const MAX_ALIAS_LENGTH = 128;
 
    protected const RETRY_ERROR_CODES = [
        40613, // Azure Sql Database paused
    ];

    string savePointSQL(name) {
        return "SAVE TRANSACTION t" ~ name;
    }

    string releaseSavePointSQL(name) {
        // SQLServer has no release save point operation.
        return null;
    }
    /*

    protected const STATEMENT_CLASS = SqlserverStatement.classname;

    /**
     * Establishes a connection to the database server.
     *
     * Please note that the PDO.ATTR_PERSISTENT attribute is not supported by
     * the SQL Server UIM PDO drivers.  As a result you cannot use the
     * persistent config option when connecting to a SQL Server 
     */
    void connect() {
        if (_pdo !is null) {
            return;
        }

        if (configuration.hasKey("persistent") && configuration.get("persistent")) {
            throw new DInvalidArgumentException(
                "Config setting 'persistent' cannot be set to true, "
                ~ "as the Sqlserver PDO driver does not support PDO.ATTR_PERSISTENT"
           );
        }
        configuration.get("flags").data([
            PDO.ATTR_ERRMODE: PDO.ERRMODE_EXCEPTION,
        ]);

        if (!configuration.isEmpty("encoding")) {
            configuration.set("flags."~PDO.SQLSRV_ATTR_ENCODING, configuration.get("encoding"));
        }
        string port = configuration.getString("port");
        }

        string dsn = "sqlsrv:Server={host}{port};Database={database};MultipleActiveResultsets=false" 
        ~ (configuration.hasKey("app") ? ";APP={app}" : null)
        ~ (configuration.hasKey("connectionPooling") ? ";ConnectionPooling={connectionPooling}" : null)
        ~ (configuration.hasKey("failoverPartner") ? ";Failover_Partner={failoverPartner}" : null)
        ~ (configuration.hasKey("loginTimeout") ? ";LoginTimeout={loginTimeout}" : null)
        ~ (configuration.hasKey("multiSubnetFailover") ? ";MultiSubnetFailover={multiSubnetFailover}" : null)
        ~ (configuration.hasKey("encrypt") ? ";Encrypt={encrypt}" : null)
        ~ (configuration.hasKey("trustServerCertificate") ? ";TrustServerCertificate={trustServerCertificate}" : null);

        dsn = dsn.mustache(configuration, ["host", "port", "database", "app", "connectionPooling", "failoverPartner", 
            "loginTimeout", "multiSubnetFailover", "encrypt", "trustServerCertificate"]);

        _pdo = createPdo(dsn, configData);
        if (!configuration.isEmpty("init")) {
            configuration.getArray("init")
                .each!(command => _pdo.exec(command));
        }
        if (!configuration.isEmpty("settings") && configuration.isArray("settings")) {
            configuration.getMap("settings").byKeyValue
                .each!(kv => _pdo.exec("SET %s %s".format(kv.key, kv.value)));
        }
        if (!configuration.isEmpty("attributes") && configuration.isArray("attributes")) {
            configuration.getMap("attributes").byKeyValue
                .each(kv => _pdo.setAttribute(kv.key, kv.value));
        }
    }
    
    // Returns whether UIM is able to use this driver for connecting to database
    bool enabled() {
        return PDO.getAvailableDrivers().contains("sqlsrv");
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

       auto statement = getPdo().prepare(
            sql,
            [
                PDO.ATTR_CURSOR: PDO.CURSOR_SCROLL,
                PDO.SQLSRV_ATTR_CURSOR_SCROLL_TYPE: PDO.SQLSRV_CURSOR_BUFFERED,
            ]
       );

        auto typeMap = null;
        if (cast(DSelectQuery)aQuery  && aQuery.isResultsCastingEnabled()) {
            typeMap = aQuery.getSelectTypeMap();
        }

        // return new (STATEMENT_CLASS)(statement, this, typeMap);
        return null; // TODO
     }



    string rollbackSavePointSQL(name) {
        return "ROLLBACK TRANSACTION t" ~ name;
    }

    override string disableForeignKeySQL() {
        return "EXEC sp_MSforeachtable \"ALTER TABLE ? NOCHECK CONSTRAINT all\"";
    }
    
    override string enableForeignKeySQL() {
        return "EXEC sp_MSforeachtable \"ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all\"";
    }
 
    bool supports(DriverFeatures feature) {
        return match (feature) {
            DriverFeatures.CTE,
            DriverFeatures.DISABLE_CONSTRAINT_WITHOUT_TRANSACTION,
            DriverFeatures.SAVEPOINT,
            DriverFeatures.TRUNCATE_WITH_CONSTRAINTS,
            DriverFeatures.WINDOW: true,

            DriverFeatures.Json: false,
        };
    }
 
    DSchemaDialect schemaDialect() {
        return _schemaDialect ? _schemaDialect : new DSqlserverSchemaDialect(this);
    }
    
    DQueryCompiler newCompiler() {
        return new DSqlserverCompiler();
    }
 
    protected ISelectQuery _selectQueryTranslator(SelectQuery aQuery) {
        auto numberOfRows = aQuery.clause("limit");
        auto anOffset = aQuery.clause("offset");

        if (numberOfRows &&  anOffset.isNull) {
            aQuery.modifier(["_auto_top_": "TOP %d".format(numberOfRows)]);
        }
        if (!anOffset.isNull && !aQuery.clause("order")) {
            aQuery.orderBy(aQuery.newExpr().add("(SELECT NULL)"));
        }
        
        return (currentVersion() < 11 &&  !anOffset.isNull)
            ? _pagingSubquery(aQuery, numberOfRows,  anOffset)
            : _transformDistinct(aQuery);
    }
    
    /**
     * Generate a paging subquery for older versions of SQLserver.
     *
     * Prior to SQLServer 2012 there was no equivalent to LIMIT OFFSET, so a subquery must
     * be used.
     * Params:
     * \UIM\Database\Query\SelectQuery<mixed>  original The query to wrap in a subquery.
     */
    protected ISelectQuery _pagingSubquery(SelectQuery  original, int numberOfRows, int rowsOffset) {
        auto field = "_uim_paging_._uim_page_rownum_";

        if (original.clause("order")) {
            // SQL server does not support column aliases in OVER clauses.  But
            // the only practical way to specify the use of calculated columns
            // is with their alias.  So substitute the select SQL in place of
            // any column aliases for those entries in the order clause.
            auto select = original.clause("select");
            auto order = new DOrderByExpression();
             original
                .clause("order")
                .iterateParts(function (direction,  orderBy) use (select,  order) {
                    aKey = orderBy;
                    if (
                        select.hasKey(orderBy) &&
                        cast(IExpression)select[orderBy] 
                   ) {
                         order.add(new DOrderClauseExpression(select[orderBy],  direction));
                    } else {
                         order.add([aKey:  direction]);
                    }
                    // Leave original order clause unchanged.
                    return orderBy;
                });
        } else {
             order = new DOrderByExpression("(SELECT NULL)");
        }

        auto aQuery =   original.clone;
        aQuery.select([
                "_uim_page_rownum_": new DUnaryExpression("ROW_NUMBER() OVER",  order),
            ]).limit(null)
            .offset(null)
            .orderBy([], true);

        auto outer = aQuery.getConnection().selectQuery();
         outer.select("*")
            .from(["_uim_paging_": aQuery]);

        if (rowsOffset) {
             outer.where(["field > " ~  rowsOffset]);
        }
        if (numberOfRows) {
            aValue = (int) rowsOffset + numberOfRows;
             outer.where(["field <= aValue"]);
        }
        // Decorate the original query as that is what the
        // end developer will be calling execute() on originally.
         original.decorateResults(function (row) {
            if (row.hasKey(["_uim_page_rownum_"])) {
                row.remove("_uim_page_rownum_");
            }
            return row;
        });

        return outer;
    }
 
    protected ISelectQuery _transformDistinct(SelectQuery aQuery) {
        if (!isArray(aQuery.clause("distinct"))) {
            return aQuery;
        }
         original = aQuery;
        aQuery =   original.clone;

         distinct = aQuery.clause("distinct");
        aQuery.distinct(false);

         order = new DOrderByExpression(distinct);
        aQuery
            .select(function (q) use (distinct,  order) {
                 over = q.newExpr("ROW_NUMBER() OVER")
                    .add("(PARTITION BY")
                    .add(q.newExpr().add(distinct).conjunctionType(","))
                    .add(order)
                    .add(")")
                    .conjunctionType(" ");

                return [
                    "_uim_distinct_pivot_": over,
                ];
            })
            .limit(null)
            .offset(null)
            .orderBy([], true);

         outer = new DSelectQuery(aQuery.getConnection());
         outer.select("*")
            .from(["_uim_distinct_": aQuery])
            .where(["_uim_distinct_pivot_": 1]);

        // Decorate the original query as that is what the
        // end developer will be calling execute() on originally.
         original.decorateResults(function (row) {
             
                row.remove("_uim_distinct_pivot_");
            return row;
        });

        return outer;
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
    protected void _transformFunctionExpression(FunctionExpression expression) {
        switch (expression.name) {
            case "CONCAT": 
                // CONCAT bool is expressed as exp1 + exp2
                expression.name("").conjunctionType(" +");
                break;
            case "DATEDIFF": 
                $hasDay = false;
                 visitor = auto (aValue) use (&$hasDay) {
                    if (aValue == "day") {
                        $hasDay = true;
                    }
                    return aValue;
                };
                expression.iterateParts(visitor);

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
                expression.name("DATEPART").conjunctionType(" ,");
                break;
            case "DATE_ADD": 
                params = null;
                 visitor = auto (p, aKey) use (&params) {
                    if (aKey == 0) {
                        params[2] = p;
                    } else {
                        string[] valueUnit = p.split(" ");
                        params[0] = stripRight(valueUnit[1], "s");
                        params[1] = valueUnit[0];
                    }
                    return p;
                };
                 manipulator = auto (p, aKey) use (&params) {
                    return params[aKey];
                };

                expression
                    .name("DATEADD")
                    .conjunctionType(",")
                    .iterateParts(visitor)
                    .iterateParts(manipulator)
                    .add([params[2]: "literal"]);
                break;
            case "DAYOFWEEK": 
                expression
                    .name("DATEPART")
                    .conjunctionType(" ")
                    .add(["weekday, ": "literal"], [], true);
                break;
            case "SUBSTR": 
                expression.name("SUBSTRING");
                if (count(expression) < 4) {
                    params = null;
                    expression
                        .iterateParts(function (p) use (&params) {
                            return params ~= p;
                        })
                        .add([new DFunctionExpression("LEN", [params[0]]), ["string"]]);
                }
                break;
        }
    } 
}
