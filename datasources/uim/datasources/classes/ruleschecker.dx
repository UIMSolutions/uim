
module uim.datasources;

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
class RulesChecker {
  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}

    // Indicates that the checking rules to apply are those used for creating entities
    const string CREATE = "create";

    // Indicates that the checking rules to apply are those used for updating entities
    const string UPDATE = "update";

    // Indicates that the checking rules to apply are those used for deleting entities
    const string DELETE = "delete";

    // The list of rules to be checked on both create and update operations
    protected RuleInvoker[] _rules = [];

    // The list of rules to check during create operations
    protected RuleInvoker[] _createRules = [];

    // The list of rules to check during update operations
    protected RuleInvoker[] _updateRules = [];

    // The list of rules to check during delete operations
    protected RuleInvoker[] _deleteRules = [];

    // List of options to pass to every callable rule
    protected array _options = [];

    // Whether to use I18n functions for translating default error messages
    protected bool _useI18n = false;

    /**
     * Constructor. Takes the options to be passed to all rules.
     * Params:
     * IData[string] optionData The options to pass to every rule
     */
    this(IData[string] optionData = null) {
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
     * @param string[]|null name The alias for a rule, or an array of options.
     * @param IData[string] optionData List of extra options to pass to the rule callable as
     * second argument.
     */
    void add(callable rule, string[]|null name = null, IData[string] optionData = null) {
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
     * @param string[]|null name The alias for a rule or an array of options.
     * @param IData[string] optionData List of extra options to pass to the rule callable as
     * second argument.
     */
    void addCreate(callable rule, string[]|null name = null, IData[string] optionData = null) {
       _createRules ~= _addError(rule, name, options);
    }
<<<<<<< HEAD
    
=======

>>>>>>> 74a7b6400cdc9ef55c74d50ddcb3fb9c29d1e0bf
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
     * @param string[]|null name The alias for a rule, or an array of options.
     * @param IData[string] optionData List of extra options to pass to the rule callable as
     * second argument.
     */
    auto addUpdate(callable rule, string[]|null name = null, IData[string] optionData = null) {
       _updateRules ~= _addError(rule, name, options);

        return this;
    }
<<<<<<< HEAD
    
=======

>>>>>>> 74a7b6400cdc9ef55c74d50ddcb3fb9c29d1e0bf
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
     * @param string[]|null name The alias for a rule, or an array of options.
     * @param IData[string] optionData List of extra options to pass to the rule callable as
     * second argument.
     */
    auto addDelete_(callable rule, string[]|null name = null, IData[string] optionData = null) {
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
     * @param IData[string] optionData Extra options to pass to checker functions.
     * @throws \InvalidArgumentException if an invalid mode is passed.
     */
    bool check(IEntity entity, string amode, IData[string] optionData = null) {
        if (mode == self.CREATE) {
            return this.checkCreate(entity, options);
        }
        if (mode == self.UPDATE) {
            return this.checkUpdate(entity, options);
        }
        if (mode == self.DELETE) {
            return this.checkDelete_(entity, options);
        }
        throw new InvalidArgumentException("Wrong checking mode: " ~ mode);
    }
<<<<<<< HEAD
    
=======

>>>>>>> 74a7b6400cdc9ef55c74d50ddcb3fb9c29d1e0bf
    /**
     * Runs each of the rules by passing the provided entity and returns true if all
     * of them pass. The rules selected will be only those specified to be run on 'create'
     * Params:
     * \UIM\Datasource\IEntity entity The entity to check for validity.
     * @param IData[string] optionData Extra options to pass to checker functions.
     */
   bool checkCreate(IEntity entity, IData[string] optionData = null) {
        return _checkRules(entity, options, array_merge(_rules, _createRules));
    }
<<<<<<< HEAD
    
=======

>>>>>>> 74a7b6400cdc9ef55c74d50ddcb3fb9c29d1e0bf
    /**
     * Runs each of the rules by passing the provided entity and returns true if all
     * of them pass. The rules selected will be only those specified to be run on 'update'
     * Params:
     * \UIM\Datasource\IEntity entity The entity to check for validity.
     * @param IData[string] optionData Extra options to pass to checker functions.
     */
   bool checkUpdate(IEntity entity, IData[string] optionData = null) {
        return _checkRules(entity, options, chain(_rules, _updateRules));
    }
<<<<<<< HEAD
    
=======

>>>>>>> 74a7b6400cdc9ef55c74d50ddcb3fb9c29d1e0bf
    /**
     * Runs each of the rules by passing the provided entity and returns true if all
     * of them pass. The rules selected will be only those specified to be run on 'delete'
     * Params:
     * \UIM\Datasource\IEntity entity The entity to check for validity.
     * @param IData[string] optionData Extra options to pass to checker functions.
     */
    bool checkDelete_(IEntity entity, IData[string] optionData = null) {
        return _checkRules(entity, options, _deleteRules);
    }
    
    /**
     * Used by top level functions checkDelete, checkCreate and checkUpdate, this function
     * iterates an array containing the rules to be checked and checks them all.
     * Params:
     * \UIM\Datasource\IEntity entity The entity to check for validity.
     * @param IData[string] optionData Extra options to pass to checker functions.
     * @param array<\UIM\Datasource\RuleInvoker> rules The list of rules that must be checked.
     */
    protected bool _checkRules(IEntity entity, IData[string] optionData = null, array rules = []) {
        success = true;
        options += _options;
        rules
          .each!(rule => success = rule(entity, options) && success);
        return success;
    }
    
    /**
     * Utility method for decorating any callable so that if it returns false, the correct
     * property in the entity is marked as invalid.
     * Params:
     * \UIM\Datasource\RuleInvoker|callable rule The rule to decorate
     * @param string[]|null name The alias for a rule or an array of options
     * @param IData[string] optionData The options containing the error message and field.
     */
    protected RuleInvoker _addError(callable rule, string[]|null name = null, IData[string] optionData = null) {
        if (isArray(name)) {
            options = name;
            name = null;
        }
        if (!cast(RuleInvoker)rule)) {
            rule = new RuleInvoker(rule, name, options);
        } else {
            rule.setOptions(options).name(name);
        }
        return rule;
    }
}
