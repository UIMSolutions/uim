module uim.validations.classes.rules.rule;

import uim.validations;
@safe:

version (test_uim_validations) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
} 

/**
 * ValidationRule object. Represents a validation method, error message and
 * rules for applying such method to a field.
 */
class DValidationRule {
    // /The method to be called for a given scope
    protected string _rule;

    // The "last" key
    protected bool _last = false;

    // Returns whether this rule should break validation process for associated field after it fails
    bool isLast() {
        return _last;
    }

    // The "message" key
    protected string _message = null;

    /**
     * Key under which the object or class where the method to be used for
     * validation will be found
     */
    protected string _provider = "default";

    // The "on" key
    protected string _on = null;

    // Extra arguments to be passed to the validation method
    protected Json[string] _pass = null;

    /**
     * Dispatches the validation rule to the given validator method and returns
     * a boolean indicating whether the rule passed or not. If a string is returned
     * it is assumed that the rule failed and the error message was given as a result.
     */
    string[] process(Json value, Json[string] providers, Json[string] context = null) {
        // TODO
        return null;
    }

    protected bool shouldBeSkipped(Json[string] context) {
        // TODO 
        return false;
    }

    // Sets the rule properties from the rule entry in validate
    protected void addValidatorProps(Json[string] validator = null) {
        // TODO
    }
}
