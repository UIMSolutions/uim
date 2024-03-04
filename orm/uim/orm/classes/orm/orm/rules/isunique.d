module uim.orm.Rule;

import uim.orm;

@safe:

/*
 * Checks that a list of fields from an entity are unique in the table
 */
class IsUnique {
    /**
     * The list of fields to check
     */
    protected string[] my_fields;

    /**
     * The unique check options
     */
    protected IData[string] my_options = [
        "allowMultipleNulls": true,
    ];

    /**
     * Constructor.
     *
     * ### Options
     *
     * - `allowMultipleNulls` Allows any field to have multiple null values. Defaults to true.
     * Params:
     * string[] myfields The list of fields to check uniqueness for
     * @param IData[string] options The options for unique checks.
     */
    this(array myfields, IData[string] optionData = null) {
       _fields = myfields;
       _options = options + _options;
    }
    
    // Performs the uniqueness check
   bool __invoke(IEntity entity, IData[string] options) {
        if (!entity.extract(_fields, true)) {
            return true;
        }
        myfields = entity.extract(_fields);
        if (_options["allowMultipleNulls"] && array_filter(myfields, "is_null")) {
            return true;
        }
        auto myalias = options["repository"].aliasName();
        
        auto myconditions = _alias(myalias, myfields);
        if (entity.isNew() == false) {
            auto someKeys = (array)options["repository"].getPrimaryKey();
            someKeys = _alias(myalias, entity.extract(someKeys));
            if (Hash.filter(someKeys)) {
                myconditions["NOT"] = someKeys;
            }
        }
        return !options["repository"].exists(myconditions);
    }
    
    // Add a model aliasToAdd to all the keys in a set of conditions.
    protected IData[string] _alias(string myalias, array aliasConditions) {
        auto myaliased = [];
        aliasConditions.byKeyValue
            .each!(kv => myaliased["aliasToAdd.aKey IS"] = kv.value);
        return myaliased;
    }
}
