module uim.datasources.classes.rules.invoker;

import uim.datasources;

@safe:

/**
 * Contains logic for invoking an application rule.
 *
 * Combined with {@link \UIM\Datasource\RulesChecker} as an implementation
 * detail to de-duplicate rule decoration and provide cleaner separation
 * of duties.
 *
 * @internal
 */
class DRuleInvoker {
    // The rule name
    protected string _ruleName;

    // Rule options
    protected Json[string] _options = null;

    /* 
    // Rule callable
    protected callable _rule;

    /**
     * ### Options
     *
     * - `errorField` The field errors should be set onto.
     * - `message` The error message.
     *
     * Individual rules may have additional options that can be set here. 
     * Any options will be passed into the rule as part of the rule scope.
     */
    this(callable rule, string ruleName, Json[string] ruleOptions = null) {
        _rule = rule;
        _ruleName = ruleName;
        _options = ruleOptions;
    }
    
    /**
     * Set options for the rule invocation.
     *
     * Old options will be merged with the new ones.
     * Params:
     * Json[string] optionData The options to set.
     */
    void updateOptions(Json[string] additionalOptions = null) {
        _options = _options.update(additionalOptions);
    }
    
    /**
     * Set the rule name.
     * Only truthy names will be set.
     */
    void name(string ruleName) {
        if (!ruleName.isEmpty) {
            _ruleName = ruleName;
        }
    }
    
    // Invoke the rule.
    bool __invoke(IDatasourceEntity entity, Json[string] ruleOptions) {
        rule = _rule;
        pass = rule(entity, this.options + scope);
        if (pass == true || configuration.isEmpty("errorField")) {
            return pass == true;
        }
        
        string message = configuration.getString("message", "invalid");
        if (isString(pass)) {
            message = pass;
        }
        
        message = _ruleName ? [_ruleName: message] : [message];

        errorField = configuration.set("errorField"];
        entity.setErrors(errorField, message);

        if (cast(IInvalidProperty)entity && isSet(entity.{errorField})) {
             anInvalidValue = entity.{errorField};
            entity.setInvalidField(errorField,  anInvalidValue);
        }
        /** @Dstan-ignore-next-line */
        return pass == true;
    } */
}
