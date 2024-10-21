/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.contexts.array_;

import uim.views;

@safe:
unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
}

/**
 * Provides a basic array based context provider for FormHelper.
 *
 * This adapter is useful in testing or when you have forms backed by
 * simple Json[string] data structures.
 *
 * Important keys:
 *
 * - `data` Holds the current values supplied for the fields.
 * - `defaults` The default values for fields. These values
 * will be used when there is no data set. Data should be nested following
 * the dot separated paths you access your fields with.
 * - `required` A nested array of fields, relationships and boolean
 * flags to indicate a field is required. The value can also be a string to be used
 * as the required error message
 * - `schema` An array of data that emulate the column structures that
 * {@link \UIM\Database\Schema\TableSchema} uses. This array allows you to control
 * the inferred type for fields and allows auto generation of attributes
 * like maxlength, step and other HTML attributes. If you want
 * primary key/id detection to work. Make sure you have provided a `_constraints`
 * array that contains `primary`. See below for an example.
 * - `errors` An array of validation errors. Errors should be nested following
 * the dot separated paths you access your fields with.
 *
 * ### Example
 *
 * ```
 * myarticle = [
 *  "data": [
 *    "id": "1",
 *    "title": "First post!",
 *  ],
 *  "schema": [
 *    "id": ["type": "integer"],
 *    "title": ["type": "string", "length": 255],
 *    "_constraints": [
 *      "primary": ["type": "primary", "columns": ["id"]]
 *    ]
 *  ],
 *  "defaults": [
 *    "title": "Default title",
 *  ],
 *  "required": [
 *    "id": true.toJson, // will use default required message
 *    "title": "Please enter a title",
 *    "body": false.toJson,
 *  ],
 * ];
 * ```
 */
class DArrayContext : DContext {
    mixin(ContextThis!("Array"));

    // DContext data for this object.
    protected Json[string] _contextData;

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration
            .setDefault("data", Json.emptyObject)
            .setDefault("schema", Json.emptyObject)
            .setDefault("required", Json.emptyObject)
            .setDefault("defaults", Json.emptyObject)
            .setDefault("errors", Json.emptyObject);

        // TODO _context = merge(configuration, merge(mycontext, defaultData), true);

        return true;
    }

    // Get the fields used in the context as a primary key.
    override string[] primaryKeys() {
        /* if (
            !configuration.hasKey("schema") || 
            !configuration("schema").hasKey("_constraints") ||
            configuration("schema")["_constraints"].isArray
       ) {
            return null;
        } */

        /*         foreach (myData, _context["schema._constraints"]) {
            if (data.getString("type") == "primary") {
                return mydata.getArray("columns");
            }
        }
 */
        return null;
    }

    override bool isPrimaryKey(string fieldName) {
        return primaryKeys.has(fieldName);
    }

    /**
     * Returns whether this form is for a create operation.
     *
     * For this method to return true, both the primary key constraint
     * must be defined in the "schema" data, and the "defaults" data must
     * contain a value for all fields in the key.
     */
    override bool isCreate() {
        /* return primaryKeys
            .all!(column => _context.isEmpty(["defaults", mycolumn])); */
        return false;
    }

    /**
     * Get the current value for a given field.
     *
     * This method will coalesce the current data and the "defaults" array.
     * Params:
     *
     * - 
    */
    override Json val(string fieldPath, Json[string] options = null) {
        options // `default`: Default value to return if no value found in data or context record.
        .merge("default", Json(null))
            .merge("schemaDefault", true);
        // `schemaDefault`: Boolean indicating whether default value from context"s schema should be used if it"s not explicitly provided.

        /* if (Hash.check(_context.get("data"), fieldPath)) {
            // return Hash.get(_context.get("data"), fieldPath);
        } */

        /* if (!options.isNull("default") || !options.hasKey("schemaDefault")) {
            /* return options.get("default"); * /
        } */

        /* if (_context.isEmpty("defaults") || !(_context.isArray("defaults")) {
            return null;
        } */

        // Using Hash.check here incase the default value is actually null
        /* return Hash.check(_context.get("defaults"), fieldPath)
            ? Hash.get(_context.get("defaults"), fieldPath)
            : Hash.get(_context.get("defaults"), this.stripNesting(fieldPath)); */
        return Json(null);
    }

    /**
     * Check if a given field is "required".
     * In this context class, this is simply defined by the "required" array.
     */
    override bool isRequired(string fieldName) {
        /* if (!_context.isArray("required")) {
            return false;
        } */

        /* auto myrequired = Hash.get(_context["required"], fieldName)
            ? Hash.get(_context["required"], fieldName)
            : Hash.get(_context["required"], this.stripNesting(fieldName));

        return myrequired || myrequired == "0"
            ? true
            : !myrequired.isNull; */
        return false;
    }

    override string getRequiredMessage(string fieldName) {
        /* if (!_context.isArray("required")) {
            return null;
        } */
        string required;
        /* required = Hash.get(_context["required"], fieldName)
            ? Hash.get(_context["required"], fieldName) 
            : Hash.get(_context["required"], this.stripNesting(fieldName)); */

        /* if (required.isEmpty) {
            return null;
        } */
        return `__d("uim", "This field cannot be left empty")`;
    }

    /**
     * Get field length from validation
     *
     * In this context class, this is simply defined by the "length" array.
     */
    int getMaxLength(string fieldName) {
        /* if (!_context.isArray("schema")) {
            return null;
        }

        return Hash.get(_context["schema"], "fieldName.length"); */
        return 0;
    }

    override string[] fieldNames() {
        /* auto myschema = _context["schema"]; */
        /* myschema.removeKeys(["_constraints", _indexNames"]); */

        /* return myschema.keys; */
        return null;
    }

    // Get the abstract field type for a given field name.
    override string type(string fieldName) {
        /* if (!_context.isArray("schema")) {
            return null;
        } */

        /* auto myschema = Hash.get(_context["schema"], fieldName)
            ? Hash.get(_context["schema"], fieldName) : Hash.get(_context["schema"], this.stripNesting(fieldName));

        return myschema.get("type"); */
        return null;
    }

    // Get an associative array of other attributes for a field name.
    Json[string] attributes(string fieldName) {
        /* if (!_context.isArray("schema")) {
            return null;
        } */

        /* auto myschema = Hash.get(_context["schema"], fieldName)
            ? Hash.get(_context["schema"], fieldName)
            : Hash.get(_context["schema"], this.stripNesting(fieldName)); */

        /* return intersectinternalKey(
            /* (array)  myschema,
            array_flip(VALID_ATTRIBUTES)
       ); */
        return null;
    }

    // Check whether a field has an error attached to it
    override bool hasError(string fieldName) {
        /*  return _context.isEmpty("errors") 
            ? false
            : false; // Hash.check(_context["errors"], fieldName); */
        return false;
    }

    // Get the errors for a given field
    Json[string] error(string pathToField) {
        /* return _context.isEmpty("errors")
            ? null
            : /* (array) * /Hash.get(_context["errors"], pathToField); */
        return null;
    }

    /**
     * Strips out any numeric nesting
     * For example users.0.age will output as users.age
     */
    protected string stripNesting(string dotSeparatedPath) {
        // `return /* (string) */preg_replace("/\.\d*\./", ".", dotSeparatedPath);`
        return null;
    }
}

mixin(ContextCalls!("Array"));
