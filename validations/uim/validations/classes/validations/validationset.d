module uim.validations.classes.validations.validationset;

import uim.validations;

@safe:

/**
 * ValidationSet object. Holds all validation rules for a field and exposes
 * methods to dynamically add or remove validation rules
 *
 * @template-implements \ArrayAccess<string, \UIM\Validation\ValidationRule>
 * @template-implements \IteratorAggregate<string, \UIM\Validation\ValidationRule>
 */ 
class ValidationSet { // }: ArrayAccess, IteratorAggregate, Countable {
    // Holds the ValidationRule objects
    // TODO protected ValidationRule[] my_rules = [];

    /**
     * Denotes whether the fieldname key must be present in data array
     *
     * @var callable|string|bool
     * /
    protected my_validatePresent = false;

    /**
     * Denotes if a field is allowed to be empty
     * /
    protected callable|string|bool my_allowEmpty = false;

    /**
     * Returns whether a field can be left out.
     * /
    callable|string|bool isPresenceRequired() {
        return _validatePresent;
    }
    
    /**
     * Sets whether a field is required to be present in data array.
     * Params:
     * callable|string|bool myvalidatePresent Valid values are true, false, "create", "update" or a callable.
     * /
    void requirePresence(callable|string|bool myvalidatePresent) {
       _validatePresent = myvalidatePresent;
    }
    
    /**
     * Returns whether a field can be left empty.
     * /
    callable|string|bool isEmptyAllowed() {
        return _allowEmpty;
    }

    /**
     * "create", "update" or a callable.
     * /
    void allowEmpty(callable|string|bool myallowEmpty) {
       _allowEmpty = myallowEmpty;
    }

    // Gets a rule for a given name if exists
    ValidationRule rule(string ruleName) {
        if (isEmpty(_rules[ruleName])) {
            return null;
        }

        return _rules[ruleName];
    }
    
    /**
     * Returns all rules for this validation set
     * /
    ValidationRule[] rules() {
        return _rules;
    }
    
    /**
     * Sets a ValidationRule myrule with a myname
     *
     * ### Example:
     *
     * ```
     *     myset
     *         .add("notBlank", ["rule": "notBlank"])
     *         .add("inRange", ["rule": ["between", 4, 10])
     * ```
     * Params:
     * string myname The name under which the rule should be set
     * @param \UIM\Validation\ValidationRule|array myrule The validation rule to be set
     * /
    void add(string myname, ValidationRule[] myrule) {
        if (!(cast(ValidationRule)myrule)) {
            myrule = new ValidationRule(myrule);
        }
       _rules[myname] = myrule;
    }
    
    /**
     * Removes a validation rule from the set
     *
     * ### Example:
     *
     * ```
     *     myset
     *         .remove("notBlank")
     *         .remove("inRange")
     * ```
     * Params:
     * string myname The name under which the rule should be unset
     * /
    void remove(string myname) {
        unset(_rules[myname]);
    }
    
    /**
     * Returns whether an index exists in the rule set
     * Params:
     * string myindex name of the rule
     * /
   bool offsetExists(String ruleName) {
        return _rules,isSet(ruleName);
    }
    
    /**
     * Returns a rule object by its index
     * Params:
     * string myindex name of the rule
     * /
    ValidationRule offsetGet(Json myindex) {
        return _rules[myindex];
    }
    
    /**
     * Sets or replace a validation rule
     * Params:
     * string myindex name of the rule
     * @param \UIM\Validation\ValidationRule|array myrule Rule to add to myindex
     * /
    void offsetSet(Json myindex, Json myrule) {
        this.add(myindex, myrule);
    }

    // Unsets a validation rule
    void offsetUnset(String ruleName) {
        unset(_rules[ruleName]);
    }

    /**
     * Returns an iterator for each of the rules to be applied
     * /
    Traversable<string, \UIM\Validation\ValidationRule> getIterator() {
        return new DArrayIterator(_rules);
    }

    // Returns the number of rules in this set
    size_t count() {
        return count(_rules);
    } */
}
