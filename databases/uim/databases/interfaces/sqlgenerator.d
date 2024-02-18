/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module source.uim.databases.interfaces.sqlgenerator;

@safe:
import uim.databases;


/**
 * An interface used by TableSchema objects.
 */
interface ISqlGenerator {
    /**
     * Generate the SQL to create the Table.
     *
     * Uses the connection to access the schema dialect
     * to generate platform specific SQL.
     *
     * @param DDBAConnection $connection The connection to generate SQL for.
     * @return array List of SQL statements to create the table and the
     *    required indexes.
     */
    array createSql(Connection $connection);

    /**
     * Generate the SQL to drop a table.
     *
     * Uses the connection to access the schema dialect to generate platform
     * specific SQL.
     *
     * @param DDBAConnection $connection The connection to generate SQL for.
     * @return array SQL to drop a table.
     */
    array dropSql(Connection $connection);

    /**
     * Generate the SQL statements to truncate a table
     *
     * @param DDBAConnection $connection The connection to generate SQL for.
     * @return array SQL to truncate a table.
     */
    array truncateSql(Connection $connection);

    /**
     * Generate the SQL statements to add the constraints to the table
     *
     * @param DDBAConnection $connection The connection to generate SQL for.
     * @return array SQL to add the constraints.
     */
    array addConstraintSql(Connection $connection);

    /**
     * Generate the SQL statements to drop the constraints to the table
     *
     * @param DDBAConnection $connection The connection to generate SQL for.
     * @return array SQL to drop a table.
     */
    array dropConstraintSql(Connection $connection);
}
use uim.databases.Connection;

/**
 * An interface used by TableSchema objects.
 */
interface SqlGeneratorInterface
{
    /**
     * Generate the SQL to create the Table.
     *
     * Uses the connection to access the schema dialect
     * to generate platform specific SQL.
     *
     * @param DDBAConnection $connection The connection to generate SQL for.
     * @return array List of SQL statements to create the table and the
     *    required indexes.
     */
    function createSql(Connection $connection): array;

    /**
     * Generate the SQL to drop a table.
     *
     * Uses the connection to access the schema dialect to generate platform
     * specific SQL.
     *
     * @param DDBAConnection $connection The connection to generate SQL for.
     * @return array SQL to drop a table.
     */
    function dropSql(Connection $connection): array;

    /**
     * Generate the SQL statements to truncate a table
     *
     * @param DDBAConnection $connection The connection to generate SQL for.
     * @return array SQL to truncate a table.
     */
    function truncateSql(Connection $connection): array;

    /**
     * Generate the SQL statements to add the constraints to the table
     *
     * @param DDBAConnection $connection The connection to generate SQL for.
     * @return array SQL to add the constraints.
     */
    function addConstraintSql(Connection $connection): array;

    /**
     * Generate the SQL statements to drop the constraints to the table
     *
     * @param DDBAConnection $connection The connection to generate SQL for.
     * @return array SQL to drop a table.
     */
    function dropConstraintSql(Connection $connection): array;
}
