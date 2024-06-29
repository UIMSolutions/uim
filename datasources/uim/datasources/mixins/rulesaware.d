module uim.datasources.mixins.rulesaware;

import uim.datasources;

@safe:

/**
 * A template that allows a class to build and apply application.
 * rules.
 *
 * If the implementing class DAlso : EventAwareTrait, then
 * events will be emitted when rules are checked.
 *
 * The implementing class is expected to define the `RULES_CLASS` constant
 * if they need to customize which class is used for rules objects.
 */
mixin template TRulesAware() {
    // The domain rules to be applied to entities saved by this table
    protected DRulesChecker _rulesChecker = null;

    /**
     * Returns whether the passed entity complies with all the rules stored in
     * the rules checker.
     */
   bool checkRules(
        IDatasourceEntity entity,
        string operationToRun = RulesChecker.CREATE,
        Json[string] ruleOptions = null
   ) {
        auto rules = this.rulesChecker();
        ruleOptions = ruleOptions ?: new ArrayObject();
        ruleOptions = ruleOptions.isArray ? new ArrayObject(ruleOptions): ruleOptions;
        bool hasEvents = (cast(IEventDispatcher)this);

        if (hasEvents) {
            event = dispatchEvent(
                "Model.beforeRules",
                compact("entity", "ruleOptions", "operation")
           );
            if (event.isStopped()) {
                return event.getResult();
            }
        }
        result = rules.check(entity, operationToRun, ruleOptions.getArrayCopy());

        if (hasEvents) {
            event = dispatchEvent(
                "Model.afterRules",
                compact("entity", "options", "result", "operation")
           );

            if (event.isStopped()) {
                return event.getResult();
            }
        }
        return result;
    }
    
    /**
     * Returns the RulesChecker for this instance.
     *
     * A RulesChecker object is used to test an entity for validity
     * on rules that may involve complex logic or data that
     * needs to be fetched from relevant datasources.
     */
    RulesChecker rulesChecker() {
        if (!_rulesChecker.isNull) {
            return _rulesChecker;
        }
        /** @var class-string<\UIM\Datasource\RulesChecker>  classname */
        auto classname = defined("RULES_CLASS") ? RULES_CLASS : RulesChecker.classname;
        /**
         * @psalm-suppress ArgumentTypeCoercion
         * @Dstan-ignore-next-line
         */
        _rulesChecker = this.buildRules(new classname(["repository": this]));
        dispatchEvent("Model.buildRules", ["rules": _rulesChecker]);

        return _rulesChecker;
    }
    
    /**
     * Returns a RulesChecker object after modifying the one that was supplied.
     *
     * Subclasses should override this method in order to initialize the rules to be applied to
     * entities saved by this instance.
     */
    RulesChecker buildRules(RulesChecker rules) {
        return rules;
    } */
}