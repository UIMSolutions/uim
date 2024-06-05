
module uim.datasources.classes.rules.checker;

import uim.datasources;

@safe:

/**
 * Contains logic for storing and checking rules on entities
 *
 * RulesCheckers are used by Table classes to ensure that the
 * current entity state satisfies the application logic and business rules.
 *
 * RulesCheckers afford different rules to be applied in the create and update
 * scenario.
 *
 * ### Adding rules
 *
 * Rules must be callable objects that return true/false depending on whether
 * the rule has been satisfied. You can use RulesChecker.add(), RulesChecker.addCreate(),
 * RulesChecker.addUpdate() and RulesChecker.addDelete to add rules to a checker.
 *
 * ### Running checks
 *
 * Generally a Table object will invoke the rules objects, but you can manually
 * invoke the checks by calling RulesChecker.checkCreate(), RulesChecker.checkUpdate() or
 * RulesChecker.checkremove().
 */
class DRulesChecker {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    // Indicates that the checking rules to apply are those used for creating entities
    const string CREATE = "create";

    // Indicates that the checking rules to apply are those used for updating entities
    const string UPDATE = "update";

    // Indicates that the checking rules to apply are those used for deleting entities
    const string DELETE = "delete";

    // The list of rules to be checked on both create and update operations
    protected DRuleInvoker[] _rules;

    // The list of rules to check during create operations
    protected DRuleInvoker[] _createRules = null;

    // The list of rules to check during update operations
    protected DRuleInvoker[] _updateRules = null;

    // The list of rules to check during delete operations
    protected DRuleInvoker[] _deleteRules = null;

    // List of options to pass to every callable rule
    protected Json[string] _options = null;

    // Whether to use I18n functions for translating default error messages
    protected bool _useI18n = false;

    // Takes the options to be passed to all rules.
    this(Json[string] optionData = null) {
       _options = options;
       _useI18n = function_exists("\UIM\I18n\__d");
    }
    
    /**
     * Adds a rule that will be applied to the entity both on create and update
     * operations.
     *
     * ### Options
     *
     * The options array accept the following special keys:
     *
     * - `errorField`: The name of the entity field that will be marked as invalid
     *  if the rule does not pass.
     * - `message`: The error message to set to `errorField` if the rule does not pass.
     */
    void add(callable ruleCallable, string[] ruleAlias = null, Json[string] optionData = null) {
       _rules ~= _addError(rule, ruleAlias, optionData);
    }
    
    /**
     * Adds a rule that will be applied to the entity on create operations.
     *
     * ### Options
     *
     * The options array accept the following special keys:
     *
     * - `errorField`: The name of the entity field that will be marked as invalid
     *  if the rule does not pass.
     * - `message`: The error message to set to `errorField` if the rule does not pass.
     */
    void addCreate(callable rule, string[] ruleAlias = null, Json[string] optionData = null) {
       _createRules ~= _addError(rule, ruleAlias, optionData);
    }

    /**
     * Adds a rule that will be applied to the entity on update operations.
     *
     * ### Options
     *
     * The options array accept the following special keys:
     *
     * - `errorField`: The name of the entity field that will be marked as invalid
     *  if the rule does not pass.
     * - `message`: The error message to set to `errorField` if the rule does not pass.
     * the entity is valid or not.
     */
    auto addUpdate(callable rule, string[] ruleAlias = null, Json[string] extraRuleOptions = null) {
       _updateRules ~= _addError(rule, ruleAlias, extraRuleOptions);

        return this;
    }

    /**
     * Adds a rule that will be applied to the entity on delete operations.
     *
     * ### Options
     *
     * The options array accept the following special keys:
     *
     * - `errorField`: The name of the entity field that will be marked as invalid
     *  if the rule does not pass.
     * - `message`: The error message to set to `errorField` if the rule does not pass.
     */
    void addremove(callable rule, string[] ruleAlias = null, Json[string] optionData = null) {
       _deleteRules ~= _addError(rule, ruleAlias, options);
    }
    
    /**
     * Runs each of the rules by passing the provided entity and returns true if all
     * of them pass. The rules to be applied are depended on the mode parameter which
     * can only be RulesChecker.CREATE, RulesChecker.UPDATE or RulesChecker.DELETE
     * Params:
     */
    bool check(IDatasourceEntity entity, string checkMode /* 'create, "update' or 'delete'*/ , Json[string] optionData = null) {
        if (checkMode == CREATE) {
            return _checkCreate(entity, options);
        }
        if (checkMode == UPDATE) {
            return _checkUpdate(entity, options);
        }
        if (checkMode == DELETE) {
            return _checkremove(entity, options);
        }
        throw new DInvalidArgumentException("Wrong checking mode: " ~ checkMode);
    }
    
    /**
     * Runs each of the rules by passing the provided entity and returns true if all
     * of them pass. The rules selected will be only those specified to be run on 'create'
     */
   bool checkCreate(IDatasourceEntity entityToValidityCheck, Json[string] extraOptionData = null) {
        return _checkRules(entityToValidityCheck, extraOptionData, array_merge(_rules, _createRules));
    }
    
    /**
     * Runs each of the rules by passing the provided entity and returns true if all
     * of them pass. The rules selected will be only those specified to be run on 'update'
     */
   bool checkUpdate(IDatasourceEntity entityToCheck, Json[string] optionData = null) {
        return _checkRules(entityToCheck, optionData, chain(_rules, _updateRules));
    }

    /**
     * Runs each of the rules by passing the provided entity and returns true if all
     * of them pass. The rules selected will be only those specified to be run on 'delete'
     */
    bool checkremove(IDatasourceEntity entity, Json[string] optionData = null) {
        return _checkRules(entity, optionData, _deleteRules);
    }
    
    /**
     * Used by top level functions checkDelete, checkCreate and checkUpdate, this function
     * iterates an array containing the rules to be checked and checks them all.
     */
    protected bool _checkRules(IDatasourceEntity entity, Json[string] optionData = null, Json[string] rulesToCheck = null) {
        bool success = true;
        auto updatedOptions = optionData.update_options;
        rulesToCheck
          .each!(rule => success = rule(entity, updatedOptions) && success);
        return success;
    }
    
    /**
     * Utility method for decorating any callable so that if it returns false, the correct
     * property in the entity is marked as invalid.
     */
    protected DRuleInvoker _addError(callable rule, string[] ruleAlias = null, Json[string] optionData = null) {
        if (isArray(ruleAlias)) {
            options = ruleAlias;
            ruleAlias = null;
        }

        return !cast(RuleInvoker)rule
            ? new DRuleInvoker(rule, ruleAlias, options)
            : rule.setOptions(options).name(ruleAlias);

        return rule;
    }
}
