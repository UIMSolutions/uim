/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
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
     */
   void addColumn(string columnName, IData[string] attributes);

   // Get column data in the table.
   IData[string] columnData(string columnName);

   // Returns true if a column exists in the schema.
   bool hasColumn(string columnName);

   // Remove a column from the table schema.
   void removeColumn(string columnName);

   // Get the column names in the table.
   string[] columnNames();

   // Returns column type or null if a column does not exist.
   string getColumnType(string columnName);

   // Sets the type of column.
   void setColumnType(string columnName, string typeName);

   /**
     * Returns the base type name for the provided column.
     * This represent the database type a more complex class is based upon.
     */
   string baseColumnType(string columnName);

   // Check whether a field isNullable. Missing columns are nullable.
   bool isNullable(string columnName);

   /**
     * Returns an array where the keys are the column names in the schema
     * and the values the database type they have.
     */
   STRINGAA typeMap();

   // Get a hash of columns and their default values.
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
