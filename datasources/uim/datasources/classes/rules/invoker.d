module datasources.uim.datasources.classes.rules.invoker;

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
    protected IData[string] _options = null;

    /* 
    // Rule callable
    protected callable  _rule;

    /**
     * Constructor
     *
     * ### Options
     *
     * - `errorField` The field errors should be set onto.
     * - `message` The error message.
     *
     * Individual rules may have additional options that can be
     * set here. Any options will be passed into the rule as part of the
     * rule scope.
     * Params:
     * callable rule The rule to be invoked.
     * @param string name The name of the rule. Used in error messages.
     * @param IData[string] optionData The options for the rule. See above.
     * /
    this(callable rule, string ruleName, IData[string] ruleOptions = null) {
        _rule = rule;
        _ruleName = ruleName;
        _options = ruleOptions;
    }
    
    /**
     * Set options for the rule invocation.
     *
     * Old options will be merged with the new ones.
     * Params:
     * IData[string] optionData The options to set.
     * /
    void updateOptions(IData[string] additionalOptions = null) {
        _options = _options.update(additionalOptions);
    }
    
    /**
     * Set the rule name.
     * Only truthy names will be set.
     * /
    void name(string ruleName) {
        if (!ruleName.isEmpty) {
            _ruleName = ruleName;
        }
    }
    
    /**
     * Invoke the rule.
     * Params:
     * \UIM\Datasource\IEntity entity The entity the rule
     *  should apply to.
     * @param array scope The rule`s scope/options.
     * returns Whether the rule passed.
     * /
    bool __invoke(IEntity entity, array scope) {
        rule = _rule;
        pass = rule(entity, this.options + scope);
        if (pass == true || empty(this.options["errorField"])) {
            return pass == true;
        }
        message = this.options["message"] ?? "invalid";
        if (isString(pass)) {
            message = pass;
        }
        
        message = _ruleName ? [_ruleName: message] : [message];

        errorField = this.options["errorField"];
        entity.setErrors(errorField, message);

        if (cast(IInvalidProperty)entity && isSet(entity.{errorField})) {
             anInvalidValue = entity.{errorField};
            entity.setInvalidField(errorField,  anInvalidValue);
        }
        /** @phpstan-ignore-next-line * /
        return pass == true;
    } */
}
