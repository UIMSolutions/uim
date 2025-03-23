/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.interfaces.context;

import uim.views;
@safe:

// Interface for FormHelper context implementations.
interface IFormContext {
    Json[string] data();

    // Get the field names of the top level object in this context.
    string[] fieldNames();
    
    // Get maximum length of a field from model validation.
    size_t maxLength(string fieldName);

    // Get the fields used in the context as a primary key.
    string[] primaryKeys();

    // Returns true if the passed field name is part of the primary key for this context
    bool isPrimaryKey(string[] fieldPath);
    bool isPrimaryKey(string fieldName);

    // Returns whether this form is for a create operation.
    bool isCreate();

    /**
     * Get the current value for a given field.
     *
     * Classes implementing this method can optionally have a second argument
     * `options`. Valid key for `options` array are:
     * - `default`: Default value to return if no value found in data or
     *   context record.
     * - `schemaDefault`: Boolean indicating whether default value from
     *   context"s schema should be used if it"s not explicitly provided.
    */
    Json val(string fieldPath, Json[string] options = new Json[string]) ;

    /**
     * Check if a given field is "required".
     * In this context class, this is simply defined by the "required" array.
     */
    bool isRequired(string[] fieldPath);
    bool isRequired(string fieldName);

    // Gets the default "required" error message for a field
    string getRequiredMessage(string fieldPath);

    // Get the abstract field type for a given field name.
    string type(string fieldPath);

    // Get an associative array of other attributes for a field name.
    // TODO Json[string] attributes(string fieldPath);

    // Check whether a field has an error attached to it
    bool hasError(string fieldPath);

    // Get the errors for a given field
    // TODO DError[] errors(string fieldPath);

        // bool isRequired(string fieldName);
    /* void set(string key, string value);
    string get(string key);
    void remove(string key);
    void clear(); */
}