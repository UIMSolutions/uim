module uim.orm.classes.rules.checker;

import uim.orm;

@safe:

/**
 * ORM flavoured rules checker.
 * Adds ORM related features to the RulesChecker class.
 */
class DRulesChecker { // }: BaseRulesChecker {
    /**
     * Returns a callable that can be used as a rule for checking the uniqueness of a value
     * in the table.
     *
     * ### Example
     *
     * ```
     * myrules.add(myrules.isUnique(["email"], "The email should be unique"));
     * ```
     *
     * ### Options
     *
     * - `allowMultipleNulls` Allows any field to have multiple null values. Defaults to false.
     */
    RuleInvoker isUnique(Json[string] fieldNames, string[] errorMessage = null) {
        auto options = isArray(errorMessage) ? errorMessage : ["message": errorMessage];
        auto errorMessage = options.shift("message").getString;

        if (!errorMessage) {
            errorMessage = _useI18n
                ? __d("uim", "This value is already in use")
                : errorMessage = "This value is already in use";
        }
        myerrorField = currentValue(fieldNames);

        return _addError(new DIsUnique(fieldNames, options), "_isUnique", [
            "errorField": errorField, 
            "message": message
        ]);
    }
    
    /**
     * Returns a callable that can be used as a rule for checking that the values
     * extracted from the entity to check exist as the primary key in another table.
     *
     * This is useful for enforcing foreign key integrity checks.
     *
     * ### Example:
     *
     * ```
     * myrules.add(myrules.existsIn("author_id", "Authors", "Invalid Author"));
     *
     * myrules.add(myrules.existsIn("site_id", new DSitesTable(), "Invalid Site"));
     * ```
     *
     * Available options are error "message" and "allowNullableNulls" flag.
     * "message" sets a custom error message.
     * Set "allowNullableNulls" to true to accept composite foreign keys where one or more nullable columns are null.
     * Params:
     */
    DRuleInvoker existsIn(
        string[] /* string */ fieldName,
        DORMTable/* /*Association|* / string */ mytable,
        string[] /* string */ errorMessage = null
   ) {
        options = null;
        if (errorMessage.isArray) {
            options = errorMessage ~ ["message": Json(null)];
            errorMessage = options.shift("message").getString;
        }
        if (!errorMessage) {
            errorMessage = _useI18n
                ? __d("uim", "This value does not exist")
                : "This value does not exist";
        }
        
        auto errorField = isString(fieldName) ? fieldName : currentValue(fieldName);
        return _addError(new DExistsIn(fieldName, mytable, options), "_existsIn", [
                "errorField": errorField, 
                "message": message
            ]);
    }
    
    /**
     * Validates whether links to the given association exist.
     *
     * ### Example:
     *
     * ```
     * myrules.addUpdate(myrules.isLinkedTo("Articles", "article"));
     * ```
     *
     * On a `Comments` table that has a `belongsTo Articles` association, this check would ensure that comments
     * can only be edited as long as they are associated to an existing article.
     */
    RuleInvoker isLinkedTo(
        /* Association| */string association,
        string fieldName = null,
        string errorMessage = null
   ) {
        return _addLinkConstraintRule(
            association,
            fieldName,
            errorMessage,
            LinkConstraint.STATUS_LINKED,
            "_isLinkedTo"
       );
    }
    
    /**
     * Validates whether links to the given association do not exist.
     *
     * ### Example:
     *
     * ```
     * myrules.addremove(myrules.isNotLinkedTo("Comments", "comments"));
     * ```
     *
     * On a `Articles` table that has a `hasMany Comments` association, this check would ensure that articles
     * can only be deleted when no associated comments exist.
     */
    DRuleInvoker isNotLinkedTo(
        /*Association|*/ string association,
        string fieldName = null,
        string errorMessage = null
   ) {
        return _addLinkConstraintRule(
            association,
            fieldName,
            errorMessage,
            LinkConstraint.STATUS_NOT_LINKED,
            "_isNotLinkedTo"
       );
    }
    
    // Adds a link constraint rule.
    protected DRuleInvoker _addLinkConstraintRule(
        /* Association| */string association,
        string myerrorField,
        string errorMessage,
        string mylinkStatus,
        string ruleName
   ) {
        if (cast(DAssociation)association) {
            myassociationAlias = association.name;
            myerrorField = myerrorField.ifEmpty(association.getProperty());
        } else {
            myassociationAlias = association;

            if (myerrorField.isNull) {
                myrepository = _options.get("repository", null;
                if (cast(Table)myrepository) {
                    association = myrepository.getAssociation(association);
                    myerrorField = association.getProperty();
                } else {
                    myerrorField = Inflector.underscore(association);
                }
            }
        }
        if (!errorMessage) {
            myMessage = _useI18n
                ? __d(
                    "uim",
                    "Cannot modify row: a constraint for the `{0}` association fails.",
                    myassociationAlias
               )
                : "Cannot modify row: a constraint for the `%s` association fails."
                    .format(myassociationAlias);
        }
        myrule = new DLinkConstraint(
            association,
            mylinkStatus
       );

        return _addError(myrule, ruleName, compact("errorField", "message"));
    }
    
    // Validates the count of associated records.
    RuleInvoker validCount(
        string fieldName,
        size_t mycount = 0,
        string myoperator = ">",
        string errorMessage = null
   ) {
        if (!errorMessage) {
            if (_useI18n) {
                errorMessage = __d("uim", "The count does not match {0}{1}", [myoperator, mycount]);
            } else {
                errorMessage = "The count does not match %s%d".format(myoperator, mycount);
            }
        }
        myerrorField = fieldName;

        return _addError(
            new DValidCount(fieldName),
            "_validCount",
            compact("count", "operator", "errorField", "message")
       );
    }
}
