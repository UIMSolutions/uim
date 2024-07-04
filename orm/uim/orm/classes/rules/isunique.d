module uim.orm.classes.rules.isunique;

import uim.orm;

@safe:

// Checks that a list of fields from an entity are unique in the table
class DIsUnique {
    // The list of fields to check
    protected string[] _fields;

    /* 
    // The unique check options
    protected Json[string] _options = [
        "allowMultipleNulls": true.toJson,
    ];

    /**
     .
     *
     * ### Options
     *
     * - `allowMultipleNulls` Allows any field to have multiple null values. Defaults to true.
     * Params:
     * string[] fieldNames The list of fields to check uniqueness for
     */
    this(Json[string] fieldNames, Json[string] options = null) {
       _fields = fieldNames;
       _options = options + _options;
    }
    
    // Performs the uniqueness check
   bool __invoke(IORMEntity entity, Json[string] options = null) {
        if (!entity.extract(_fields, true)) {
            return true;
        }
        fieldNames = entity.extract(_fields);
        if (_options["allowMultipleNulls"] && array_filter(fieldNames, "is_null")) {
            return true;
        }
        auto aliasName = options.get("repository"].aliasName();
        
        auto myconditions = _alias(aliasName, fieldNames);
        if (entity.isNew() == false) {
            auto someKeys = (array)options["repository"].primaryKeys();
            someKeys = _alias(aliasName, entity.extract(someKeys));
            if (Hash.filter(someKeys)) {
                myconditions["NOT"] = someKeys;
            }
        }
        return !options["repository"].exists(myconditions);
    }
    
    // Add a model aliasToAdd to all the keys in a set of conditions.
    protected Json[string] _alias(string aliasName, Json[string] aliasConditions) {
        auto myaliased = null;
        aliasConditions.byKeyValue
            .each!(kv => myaliased["aliasToAdd.aKey IS"] = kv.value);
        return myaliased;
    }
}
