module uim.views.classes.contexts.array_;

import uim.views;

@safe:

/**
 * Provides a basic array based context provider for FormHelper.
 *
 * This adapter is useful in testing or when you have forms backed by
 * simple array data structures.
 *
 * Important keys:
 *
 * - `data` Holds the current values supplied for the fields.
 * - `defaults` The default values for fields. These values
 *  will be used when there is no data set. Data should be nested following
 *  the dot separated paths you access your fields with.
 * - `required` A nested array of fields, relationships and boolean
 *  flags to indicate a field is required. The value can also be a string to be used
 *  as the required error message
 * - `schema` An array of data that emulate the column structures that
 *  {@link \UIM\Database\Schema\TableSchema} uses. This array allows you to control
 *  the inferred type for fields and allows auto generation of attributes
 *  like maxlength, step and other HTML attributes. If you want
 *  primary key/id detection to work. Make sure you have provided a `_constraints`
 *  array that contains `primary`. See below for an example.
 * - `errors` An array of validation errors. Errors should be nested following
 *  the dot separated paths you access your fields with.
 *
 * ### Example
 *
 * ```
 * myarticle = [
 *   "data": [
 *     "id": "1",
 *     "title": "First post!",
 *   ],
 *   "schema": [
 *     "id": ["type": "integer"],
 *     "title": ["type": "string", "length": 255],
 *     "_constraints": [
 *       "primary": ["type": "primary", "columns": ["id"]]
 *     ]
 *   ],
 *   "defaults": [
 *     "title": "Default title",
 *   ],
 *   "required": [
 *     "id": BooleanData(true), // will use default required message
 *     "title": "Please enter a title",
 *     "body": BooleanData(false),
 *   ],
 * ];
 * ```
 */
class DArrayContext : DContext {
    mixin(ContextThis!("Array"));

    // DContext data for this object.
    protected IData[string] _contextData;

    override bool initialize(IData[string] initData = null) {
        if (super.initialize(initData)) {
            return false;
        }
        
        return true;
    }
    
    /* 
    this(IData[string] contextData) {
        IData[string] defaults [
            "data": IData.emptyObject,
            "schema": IData.emptyObject,
            "required": IData.emptyObject,
            "defaults": IData.emptyObject,
            "errors": IData.emptemptyObjectyArray,
        ];
       _context = merge(configuration, merge(mycontext, defaultData), true);
    }

    // Get the fields used in the context as a primary key.
    string[] getPrimaryKeys() {
        if (
            !_context.isSet("schema") ||
            !_context["schema"].isSet("_constraints") ||
            _context["schema"]["_constraints"].isArray
        ) {
            return null;
        }

        foreach (myData, _context["schema"]["_constraints"]) {
            if (isSet(mydata["type"]) && mydata["type"] == "primary") {
                return (array)(mydata["columns"] ?? []);
            }
        }
        return null;
    }
 
    bool isPrimaryKey(string pathToField) {
        myprimaryKey = this.getPrimaryKeys();

        return in_array(myfield, myprimaryKey, true);
    }
    
    /**
     * Returns whether this form is for a create operation.
     *
     * For this method to return true, both the primary key constraint
     * must be defined in the "schema" data, and the "defaults" data must
     * contain a value for all fields in the key.
     * /
    bool isCreate() {
        return getPrimaryKey
            .all!(column => _context["defaults"][mycolumn].isEmpty);
    }
    
    /**
     * Get the current value for a given field.
     *
     * This method will coalesce the current data and the "defaults" array.
     * Params:
     * string myfield A dot separated path to the field a value
     *  is needed for.
     * @param IData[string] options  Options:
     *
     *  - `default`: Default value to return if no value found in data or
     *    context record.
     *  - `schemaDefault`: Boolean indicating whether default value from
     *    context"s schema should be used if it"s not explicitly provided.
    * /
    IData val(string fieldPath, IData[string] options  = null) {
        IData options = optionData.update([
            "default": null,
            "schemaDefault": BooleanData(true)
        ]);

        if (Hash.check(_context["data"], fieldPath)) {
            return Hash.get(_context["data"], fieldPath);
        }
        if (!options["default"].isNull || !options["schemaDefault"]) {
            return options["default"];
        }
        if (_context["defaults"].isEmpty || !isArray(_context["defaults"])) {
            return null;
        }
        // Using Hash.check here incase the default value is actually null
        if (Hash.check(_context["defaults"], fieldPath)) {
            return Hash.get(_context["defaults"], fieldPath);
        }
        return Hash.get(_context["defaults"], this.stripNesting(fieldPath));
    }
    
    /**
     * Check if a given field is "required".
     *
     * In this context class, this is simply defined by the "required" array.
     * Params:
     * string myfield A dot separated path to check required-ness for.
     * /
    bool isRequired(string myfield) {
        if (!_context["required"].isArray) {
            return null;
        }

        auto myrequired = Hash.get(_context["required"], myfield)
            ? Hash.get(_context["required"], myfield)
            : Hash.get(_context["required"], this.stripNesting(myfield));

        if (myrequired || myrequired == "0") {
            return true;
        }
        return !myrequired.isNull ? (bool)myrequired : null;
    }
 
    string getRequiredMessage(string myfield) {
        if (!_context["required"].isArray) {
            return null;
        }
        myrequired = Hash.get(_context["required"], myfield)
            ?? Hash.get(_context["required"], this.stripNesting(myfield));

        if (myrequired == false) {
            return null;
        }
        if (myrequired == true) {
            myrequired = __d("uim", "This field cannot be left empty");
        }
        return myrequired;
    }
    
    /**
     * Get field length from validation
     *
     * In this context class, this is simply defined by the "length" array.
     * Params:
     * string myfield A dot separated path to check required-ness for.
     * /
    int getMaxLength(string myfield) {
        if (!_context["schema"].isArray) {
            return null;
        }

        return Hash.get(_context["schema"], "myfield.length");
    }

    array fieldNames() {
        myschema = _context["schema"];
        unset(myschema["_constraints"], myschema["_indexNames"]);

        /** @var list<string> * /
        return myschema.keys;
    }
    
    /**
     * Get the abstract field type for a given field name.
     * Params:
     * string myfield A dot separated path to get a schema type for.
     * /
    string type(string myfield) {
        if (!isArray(_context["schema"])) {
            return null;
        }
        myschema = Hash.get(_context["schema"], myfield)
            ?? Hash.get(_context["schema"], this.stripNesting(myfield));

        return myschema["type"] ?? null;
    }

    /**
     * Get an associative array of other attributes for a field name.
     * Params:
     * string myfield A dot separated path to get additional data on.
     * /
    array attributes(string myfield) {
        if (!_context["schema"].isArray) {
            return null;
        }
        myschema = Hash.get(_context["schema"], myfield)
            ?? Hash.get(_context["schema"], this.stripNesting(myfield));

        return array_intersect_key(
            (array)myschema,
            array_flip(VALID_ATTRIBUTES)
        );
    }

    /**
     * Check whether a field has an error attached to it
     * Params:
     * string myfield A dot separated path to check errors on.
     * /
    bool hasError(string myfield) {
        return _context.isEmpty("errors") 
            ? false
            : Hash.check(_context["errors"], myfield);
    }

    // Get the errors for a given field
    array error(string pathToField) {
        return _context.isEmpty("errors")
            ? null
            : (array)Hash.get(_context["errors"], pathToField);
    }

    /**
     * Strips out any numeric nesting
     *
     * For example users.0.age will output as users.age
     * /
    protected string stripNesting(string dotSeparatedPath) {
        return (string)preg_replace("/\.\d*\./", ".", dotSeparatedPath);
    } */
}
mixin(ContextCalls!("Array"));