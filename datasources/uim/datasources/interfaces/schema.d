/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.datasources.interfaces.schema;

import uim.datasources;

@safe:

// An interface used by TableSchema objects.
interface ISchema {
   // Get the name of the table.
   string name();

   /**
     * Add a column to the table.
     *
     * ### Attributes
     *
     * Columns can have several attributes:
     *
     * - `type` The type of the column. This should be
     *  one of UIM`s abstract types.
     * - `length` The length of the column.
     * - `precision` The number of decimal places to store
     *  for float and decimal types.
     * - `default` The default value of the column.
     * - `null` Whether the column can hold nulls.
     * - `fixed` Whether the column is a fixed length column.
     *  This is only present/valid with string columns.
     * - `unsigned` Whether the column is an unsigned column.
     *  This is only present/valid for integer, decimal, float columns.
     *
     * In addition to the above keys, the following keys are
     * implemented in some database dialects, but not all:
     *
     * - `comment` The comment for the column.
     * Params:
     * string columnName The name of the column
     * @param IData[string]|string aattrs The attributes for the column or the type name.
     * /
   auto addColumn(string columnName, array | string aattrs);

   /Get column data in the table.
   IData[string] getColumn(string columnName);

   // Returns true if a column exists in the schema.
   bool hasColumn(string columnName) : bool;

   /**
     * Remove a column from the table schema.
     *
     * If the column is not defined in the table, no error will be raised.
     * /
   auto removeColumn(string columnName);

   // Get the column names in the table.
   string[] columnNames();

   /**
     * Returns column type or null if a column does not exist.
     * Params:
     * string columnName The column to get the type of.
     */
   string getColumnType(string columnName);

   /**
     * Sets the type of column.
     * Params:
     * string columnName The column to set the type of.
     * @param string atype The type to set the column to.
     */
   void setColumnType(string columnName, string atype);

   /**
     * Returns the base type name for the provided column.
     * This represent the database type a more complex class is
     * based upon.
     * Params:
     * string acolumn The column name to get the base type from
     */
   string baseColumnType(string acolumn);

   // Check whether a field isNullable. Missing columns are nullable.
   bool isNullable(string columnName);

   /**
     * Returns an array where the keys are the column names in the schema
     * and the values the database type they have.
     */
   STRINGAA typeMap();

   /**
     * Get a hash of columns and their default values.
     */
   IData[string] defaultValues();

   /**
     * Sets the options for a table.
     *
     * Table options allow you to set platform specific table level options.
     * For example the engine type in MySQL.
     */
   void setOptions(IData[string] optionData);

   /**
     * Gets the options for a table.
     *
     * Table options allow you to set platform specific table level options.
     * For example the engine type in MySQL.
     */
   IData[string] getOptions();
}
