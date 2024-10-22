/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.tests.fixtures.schemaloader;

import uim.oop;

@safe:

/*
use InvalidArgumentException;
/**
 * Create test database schema from one or more SQL dump files.
 *
 * This class DCan be useful to create test database schema when
 * your schema is managed by tools external to your UIM
 * application.
 *
 * It is not well suited for applications/plugins that need to
 * support multiple database platforms. You should use migrations
 * for that instead.
 */
class DSchemaLoader {
    protected DConnectionHelper _helper;

    this() {
        _helper = new DConnectionHelper();
    }

    // Load and apply schema sql file, or an array of files.
    void loadSqlFiles(
        string fileToLoad,
        string connectionName = "test",
        bool shouldDropTables = true,
        bool truncateTables = false
    ) {
        loadSqlFiles([fileToLoad], connectionName, shouldDropTables, truncateTables);
    }

    void loadSqlFiles(
        string[] filesToLoad,
        string connectionName = "test",
        bool shouldDropTables = true,
        bool truncateTables = false
    ) {
        auto filePaths = filesToLoad.dup;

        // Don"t create schema if we are in a Dunit separate process test method.
        // TODO 
        /* if (GLOBALS.hasKey("__DUNIT_BOOTSTRAP")) {
            return;
        } */
        if (shouldDropTables) {
            // TODO _helper.dropTables(aConnectionName);
        }
        /** @var \UIM\Database\Connection aConnection */
        // TODO aConnection = ConnectionManager.get(aConnectionName);
        // TODO 
        /* 
        filePaths.each!((filePath) {
            if (!filehasKey(filePath)) {
                throw new DInvalidArgumentException(
                    "Unable to load SQL file `%s`."
                    .format(filePath));
            }
            
            auto sql = file_get_contents(filePath);
            if (sql.isEmpty) {
                throw new UIMException("Cannot read file content of `%s`".format(filePath));
            }
            // Use the underlying PDO connection so we can avoid prepared statements
            // which don"t support multiple queries in postgres.
            auto driver = aConnection.getDriver();
            driver.exec(sql);
        }); 
        
        if (truncateTables) {
            _helper.truncateTables(connectionName);
        } */
    }

    /**
     * Load and apply UIM schema file.
     *
     * This method will process the array returned by `file` and treat
     * the contents as a list of table schema.
     *
     * An example table is:
     *
     * ```
     * return [
     * "articles": [
     *    "columns": [
     *        "id": [
     *            "type": "integer",
     *        ],
     *        "author_id": [
     *            "type": "integer",
     *            "null": true.toJson,
     *        ],
     *        "title": [
     *            "type": "string",
     *            "null": true.toJson,
     *        ],
     *        "body": "text",
     *        "published": [
     *            "type": "string",
     *            "length": 1,
     *            "default": "N",
     *        ],
     *    ],
     *    "constraints": [
     *        "primary": [
     *            "type": "primary",
     *            "columns": [
     *                "id",
     *            ],
     *        ],
     *    ],
     * ],
     * ];
     * ```
     *
     * This schema format can be useful for plugins that want to include
     * tables to test against but don"t need to include production
     * ready schema via migrations. Applications should favour using migrations
     * or SQL dump files over this format for ease of maintenance.
     *
     * A more complete example can be found in `tests/schema.d`.
     */
    void loadInternalFile(string schemaFile, string connectionName = "test") {
        // Don"t reload schema when we are in a separate process state.
        // TODO 
        /* if (GLOBALS.hasKey("__DUNIT_BOOTSTRAP")) {
            return;
        } */
        // TODO _helper.dropTables(connectionName);

        // TODO aTables = include file;
        // TODO auto connection = ConnectionManager.get(connectionName);

        // TODO 
        /* 
        aConnection.disableConstraints(void (Connection aConnection) use (aTables) {
            foreach (tableName, aTable; aTables) {
                string name = aTable.getString("table", tableName);
                
                auto tableSchema = new DTableSchema(name, aTable["columns"]);
                if (aTable.hasKey("indexes")) {
                    aTable["indexes"].byKeyValue.each(kv => tableSchema.addIndex(kv.key, kv.value));
                }
                if (aTable.hasKey("constraints")) {
                    aTable["constraints"].byKeyValue
                        .each!(kv => tableSchema.addConstraint(aKey,  anIndex));
                }
                
                // Generate SQL for each table.
                tableSchema.createSql(aConnection).each!(sql => aConnection.execute(sql));
            }
        }); */
    }
}
