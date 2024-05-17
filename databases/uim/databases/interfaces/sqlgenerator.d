/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.databases.interfaces.sqlgenerator;

import uim.databases;

@safe:
// An interface used by TableSchema objects.
interface ISqlGenerator {
    /**
     * Generate the SQL to create the Table.
     *
     * Uses the connection to access the schema dialect
     * to generate platform specific SQL.
     *
     * @param DDBAConnection connection The connection to generate SQL for.
     * @return Json[string] List of SQL statements to create the table and the
     *    required indexes.
     */
    //TODO Json[string] createSql(Connection connection);

    /**
     * Generate the SQL to drop a table.
     *
     * Uses the connection to access the schema dialect to generate platform
     * specific SQL.
     *
     * @param DDBAConnection connection The connection to generate SQL for.
     * @return Json[string] SQL to drop a table.
     */
    //TODO Json[string] dropSql(Connection connection);

    /**
     * Generate the SQL statements to truncate a table
     *
     * @param DDBAConnection connection The connection to generate SQL for.
     * @return Json[string] SQL to truncate a table.
     */
    //TODO Json[string] truncateSql(Connection connection);

    /**
     * Generate the SQL statements to add the constraints to the table
     * @param DDBAConnection connection The connection to generate SQL for.
     */
    Json[string] addConstraintSql(Connection connection);

    /**
     * Generate the SQL statements to drop the constraints to the table
     *
     * @param DDBAConnection connection The connection to generate SQL for.
     */
    Json[string] dropConstraintSql(Connection connection);
}
/* use uim.databases.Connection;

// An interface used by TableSchema objects.
interface ISqlGenerator {
    /**
     * Generate the SQL to create the Table.
     *
     * Uses the connection to access the schema dialect
     * to generate platform specific SQL.
     *
     * @param DDBAConnection connection The connection to generate SQL for.
     * @return Json[string] List of SQL statements to create the table and the
     *    required indexes.
     */
    Json[string] createSql(Connection connection);

    /**
     * Generate the SQL to drop a table.
     *
     * Uses the connection to access the schema dialect to generate platform
     * specific SQL.
     *
     * @param DDBAConnection connection The connection to generate SQL for.
     * @return Json[string] SQL to drop a table.
     */
    Json[string] dropSql(Connection connection);

    /**
     * Generate the SQL statements to truncate a table
     *
     * @param DDBAConnection connection The connection to generate SQL for.
     */
    Json[string] truncateSql(Connection connection);

    /**
     * Generate the SQL statements to add the constraints to the table
     *
     * @param DDBAConnection connection The connection to generate SQL for.
     * @return Json[string] SQL to add the constraints.
     */
    Json[string] addConstraintSql(Connection connection);

    /**
     * Generate the SQL statements to drop the constraints to the table
     *
     * @param DDBAConnection connection The connection to generate SQL for.
     * @return Json[string] SQL to drop a table.
     */
    Json[string] dropConstraintSql(Connection connection);
    
} */
