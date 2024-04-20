module uim.views.interfaces.context;

import uim.views;

@safe:

// Interface for FormHelper context implementations.
interface IContext {
    /* 
    // Get the fields used in the context as a primary key.
    string[] getPrimaryKeys();

    // Returns true if the passed field name is part of the primary key for this context
    bool isPrimaryKey(string fieldPath);

    // Returns whether this form is for a create operation.
    bool isCreate();

    /**
     * Get the current value for a given field.
     *
     * Classes implementing this method can optionally have a second argument
     * `options`. Valid key for `options` array are:
     *  - `default`: Default value to return if no value found in data or
     *    context record.
     *  - `schemaDefault`: Boolean indicating whether default value from
     *    context"s schema should be used if it"s not explicitly provided.
    * /
    IData val(string fieldPath, IData[string] options  = null) ;

    /**
     * Check if a given field is "required".
     *
     * In this context class, this is simply defined by the "required" array.
     * /
    bool isRequired(string fieldPath);

    // Gets the default "required" error message for a field
    string getRequiredMessage(string fieldPath);

    // Get maximum length of a field from model validation.
    int getMaxLength(string fieldName) ;

    // Get the field names of the top level object in this context.
    string[] fieldNames();

    // Get the abstract field type for a given field name.
    string type(string fieldPath);

    // Get an associative array of other attributes for a field name.
    // TODO array attributes(string fieldPath);

    // Check whether a field has an error attached to it
    bool hasError(string fieldPath);

    // Get the errors for a given field
    // TODO DError[] errors(string fieldPath);
    */
}