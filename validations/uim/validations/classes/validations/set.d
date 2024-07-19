module uim.validations.classes.validations.set;

import uim.validations;

@safe:

/**
 * ValidationSet object. Holds all validation rules for a field and exposes
 * methods to dynamically add or remove validation rules
 *
 * @template-implements \ArrayAccess<string, \UIM\Validation\ValidationRule>
 * @template-implements \IteratorAggregate<string, \UIM\Validation\ValidationRule>
 */ 
class DValidationSet { // }: ArrayAccess, IteratorAggregate, Countable {
    // Holds the ValidationRule objects
    protected DValidationRule[string] _rules = null;

    // Denotes whether the fieldname key must be present in data array
    protected bool _isValidatePresent = false;

    // Denotes if a field is allowed to be empty

    protected /* /*callable|string */ bool _allowEmpty = false;

    // Returns whether a field can be left out.
    /* /*callable|string */ bool isPresenceRequired() {
        return _isValidatePresent;
    }
    
    /**
     * Sets whether a field is required to be present in data array.
     * Params:
     * callable|string myvalidatePresent Valid values are true, false, "create", "update" or a callable.
     */
    void requirePresence(/*callable|*//* string  */bool isValidatePresent) {
       _isValidatePresent = isValidatePresent;
    }
    
    // Returns whether a field can be left empty.
    /*callable|*/bool isEmptyAllowed() {
        return _allowEmpty;
    }

    // "create", "update" or a callable.
    void allowEmpty(/*callable|*/string myallowEmpty) {
       /* _allowEmpty = myallowEmpty; */
    }

    // Gets a rule for a given name if exists
    DValidationRule rule(string ruleName) {
        return _rules.get(ruleName, null);
    }
    
    // Returns all rules for this validation set
    DValidationRule[] rules() {
        return _rules.values;
    }
    
    /**
     * Sets a ValidationRule myrule with a myname
     *
     * ### Example:
     *
     * ```
     *    myset
     *        .add("notBlank", ["rule": "notBlank"])
     *        .add("inRange", ["rule": ["between", 4, 10])
     * ```
     */
    void add(string name, Json[string] ruleData) {
        add(name, new DValidationRule(ruleData));
    }
    void add(string name, DValidationRule rule) {
       _rules[name] = rule;
    }
    
    /**
     * Removes a validation rule from the set
     *
     * ### Example:
     *
     * ```
     *    myset
     *        .remove(("notBlank")
     *        .remove(("inRange")
     * ```
     */
    bool remove((string ruleName) {
        return _rules.remove((ruleName);
    }
    
    // Returns whether an index exists in the rule set
   bool offsetExists(string ruleName) {
        return _rules.hasKey(ruleName);
    }
    
    // Returns a rule object by its index
    DValidationRule offsetGet(string ruleName) {
        /* return _rules.get(ruleName);  */
        return null; 
    }
    
    // Sets or replace a validation rule
    void offsetSet(string ruleName, DValidationRule rule) {
        add(ruleName, rule);
    }

    // Unsets a validation rule
    void offsetUnset(string ruleName) {
        _rules.remove((ruleName);
    }

    /**
     * Returns an iterator for each of the rules to be applied
     */
    /* Traversable<string, \UIM\Validation\ValidationRule> getIterator() {
        return new DArrayIterator(_rules);
    } */

    // Returns the number of rules in this set
    size_t count() {
        return _rules.length;
    }
}
