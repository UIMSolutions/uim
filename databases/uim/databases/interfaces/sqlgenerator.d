/*********************************************************************************************************
	Copyright: © 2018-2025 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.databases.interfaces.sqlgenerator;

import uim.databases;

@safe:
// An interface used by TableSchema objects.
interface ISqlGenerator {
    /**
     * Generate the SQL to create the Table.
     *
     * Uses the connection to access the schema dialect to generate platform specific SQL.
     * /
    Json[string] createSql(Connection connection);

    /**
     * Generate the SQL to drop a table.
     *
     * Uses the connection to access the schema dialect to generate platform specific SQL.
     * /
    Json[string] dropSql(DDBAConnection connection);

    // Generate the SQL statements to truncate a table
    Json[string] truncateSql(DDBAConnection connection);

    // Generate the SQL statements to add the constraints to the table
    Json[string] addConstraintSql(DDBAConnection connection);

    // Generate the SQL statements to drop the constraints to the table
    Json[string] dropConstraintSql(DDBAConnection connection);
}

// An interface used by TableSchema objects.
interface ISqlGenerator {
    /**
     * Generate the SQL to create the Table.
     *
     * Uses the connection to access the schema dialect
     * to generate platform specific SQL.
     * /
    Json[string] createSql(Connection connection);

    // Generate the SQL to drop a table.
    Json[string] dropSql(Connection connection);

    // Generate the SQL statements to truncate a table
    Json[string] truncateSql(Connection connection);

    // Generate the SQL statements to add the constraints to the table
    Json[string] addConstraintSql(Connection connection);

    // Generate the SQL statements to drop the constraints to the table
    Json[string] dropConstraintSql(Connection connection);
*/
}
