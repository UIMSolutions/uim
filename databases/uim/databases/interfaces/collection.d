/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.databases.interfaces.collection;

import uim.databases;
@safe:

/**
 * Represents a database schema collection
 *
 * Used to access information about the tables,
 * and other data in a database.
 *
 * @method string[] listTablesWithoutViews() Get the list of tables available in the current connection.
 * This will exclude any views in the schema.
 */
interface ICollection {
    /**
     * Get the list of tables available in the current connection.
     *
     * @return string[] The list of tables in the connected database/schema.
     */
    string[] listTables(): ;

    /**
     * Get the column metadata for a table.
     *
     * Caching will be applied if `cacheMetadata` key is present in the Connection
     * configuration options. Defaults to _uim_model_ when true.
     *
     * ### Options
     *
     * - `forceRefresh` - Set to true to force rebuilding the cached metadata.
     *   Defaults to false.
     *
     * @param string name The name of the table to describe.
     * @param Json[string] options The options to use, see above.
     */
    ITableSchema describe(string name, Json[string] options = null);
    */
}
