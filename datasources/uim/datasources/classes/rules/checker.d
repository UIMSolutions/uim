
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
 * RulesChecker.checkDelete_().
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

    /* 
    // List of options to pass to every callable rule
    // TODO protected array _options = null;

    // Whether to use I18n functions for translating default error messages
    protected bool _useI18n = false;

    /**
     * Constructor. Takes the options to be passed to all rules.
     * Params:
     * Json[string] optionData The options to pass to every rule
     * /
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
     *   if the rule does not pass.
     * - `message`: The error message to set to `errorField` if the rule does not pass.
     * Params:
     * callable rule A callable auto or object that will return whether
     * the entity is valid or not.
     * @param string[] name The alias for a rule, or an array of options.
     * @param Json[string] optionData List of extra options to pass to the rule callable as
     * second argument.
     * /
    void add(callable rule, string[] name = null, Json[string] options = null) {
       _rules ~= _addError(rule, name, options);
    }
    
    /**
     * Adds a rule that will be applied to the entity on create operations.
     *
     * ### Options
     *
     * The options array accept the following special keys:
     *
     * - `errorField`: The name of the entity field that will be marked as invalid
     *   if the rule does not pass.
     * - `message`: The error message to set to `errorField` if the rule does not pass.
     * Params:
     * callable rule A callable auto or object that will return whether
     * the entity is valid or not.
     * @param string[] name The alias for a rule or an array of options.
     * @param Json[string] optionData List of extra options to pass to the rule callable as
     * second argument.
     * /
    void addCreate(callable rule, string[] name = null, Json[string] optionData = null) {
       _createRules ~= _addError(rule, name, options);
    }

    /**
     * Adds a rule that will be applied to the entity on update operations.
     *
     * ### Options
     *
     * The options array accept the following special keys:
     *
     * - `errorField`: The name of the entity field that will be marked as invalid
     *   if the rule does not pass.
     * - `message`: The error message to set to `errorField` if the rule does not pass.
     * Params:
     * callable rule A callable auto or object that will return whether
     * the entity is valid or not.
     * @param string[] name The alias for a rule, or an array of options.
     * @param Json[string] optionData List of extra options to pass to the rule callable as
     * second argument.
     * /
    auto addUpdate(callable rule, string[] name = null, Json[string] optionData = null) {
       _updateRules ~= _addError(rule, name, options);

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
     *   if the rule does not pass.
     * - `message`: The error message to set to `errorField` if the rule does not pass.
     * Params:
     * callable rule A callable auto or object that will return whether
     * the entity is valid or not.
     * @param string[] name The alias for a rule, or an array of options.
     * @param Json[string] optionData List of extra options to pass to the rule callable as
     * second argument.
     * /
    auto addDelete_(callable rule, string[] name = null, Json[string] optionData = null) {
       _deleteRules ~= _addError(rule, name, options);

        return this;
    }
    
    /**
     * Runs each of the rules by passing the provided entity and returns true if all
     * of them pass. The rules to be applied are depended on the mode parameter which
     * can only be RulesChecker.CREATE, RulesChecker.UPDATE or RulesChecker.DELETE
     * Params:
     * \UIM\Datasource\IEntity entity The entity to check for validity.
     * @param string amode Either 'create, "update' or 'delete'.
     * @param Json[string] optionData Extra options to pass to checker functions.
     * @throws \InvalidArgumentException if an invalid mode is passed.
     * /
    bool check(IEntity entity, string amode, Json[string] optionData = null) {
        if (mode == self.CREATE) {
            return _checkCreate(entity, options);
        }
        if (mode == self.UPDATE) {
            return _checkUpdate(entity, options);
        }
        if (mode == self.DELETE) {
            return _checkDelete_(entity, options);
        }
        throw new DInvalidArgumentException("Wrong checking mode: " ~ mode);
    }
    
    /**
     * Runs each of the rules by passing the provided entity and returns true if all
     * of them pass. The rules selected will be only those specified to be run on 'create'
     * Params:
     * \UIM\Datasource\IEntity entity The entity to check for validity.
     * @param Json[string] optionData Extra options to pass to checker functions.
     * /
   bool checkCreate(IEntity entity, Json[string] optionData = null) {
        return _checkRules(entity, options, array_merge(_rules, _createRules));
    }
    
    /**
     * Runs each of the rules by passing the provided entity and returns true if all
     * of them pass. The rules selected will be only those specified to be run on 'update'
     * Params:
     * \UIM\Datasource\IEntity entity The entity to check for validity.
     * @param Json[string] optionData Extra options to pass to checker functions.
     * /
   bool checkUpdate(IEntity entity, Json[string] optionData = null) {
        return _checkRules(entity, options, chain(_rules, _updateRules));
    }

    /**
     * Runs each of the rules by passing the provided entity and returns true if all
     * of them pass. The rules selected will be only those specified to be run on 'delete'
     * Params:
     * \UIM\Datasource\IEntity entity The entity to check for validity.
     * @param Json[string] optionData Extra options to pass to checker functions.
     * /
    bool checkDelete_(IEntity entity, Json[string] optionData = null) {
        return _checkRules(entity, options, _deleteRules);
    }
    
    /**
     * Used by top level functions checkDelete, checkCreate and checkUpdate, this function
     * iterates an array containing the rules to be checked and checks them all.
     * Params:
     * \UIM\Datasource\IEntity entity The entity to check for validity.
     * @param Json[string] optionData Extra options to pass to checker functions.
     * @param array<\UIM\Datasource\RuleInvoker> rules The list of rules that must be checked.
     * /
    protected bool _checkRules(IEntity entity, Json[string] optionData = null, array rules = []) {
        success = true;
        options = options.update_options;
        rules
          .each!(rule => success = rule(entity, options) && success);
        return success;
    }
    
    /**
     * Utility method for decorating any callable so that if it returns false, the correct
     * property in the entity is marked as invalid.
     * Params:
     * \UIM\Datasource\RuleInvoker|callable rule The rule to decorate
     * @param string[] name The alias for a rule or an array of options
     * @param Json[string] optionData The options containing the error message and field.
     * /
    protected DRuleInvoker _addError(callable rule, string[] name = null, Json[string] optionData = null) {
        if (isArray(name)) {
            options = name;
            name = null;
        }
        if (!cast(RuleInvoker)rule)) {
            rule = new DRuleInvoker(rule, name, options);
        } else {
            rule.setOptions(options).name(name);
        }
        return rule;
    } */
}
