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
     * Params:
     * string[] fieldNames The list of fields to check for uniqueness.
     * @param Json[string]|string errorMessage The error message to show in case the rule does not pass. Can
     * also be an array of options. When an array, the "message" key can be used to provide a message.
     */
    RuleInvoker isUnique(Json[string] fieldNames, string[] errorMessage = null) {
        auto options = isArray(errorMessage) ? errorMessage : ["message": errorMessage];
        auto errorMessage = options.get("message", null);
        options.remove("message");

        if (!errorMessage) {
            if (_useI18n) {
                errorMessage = __d("uim", "This value is already in use");
            } else {
                errorMessage = "This value is already in use";
            }
        }
        myerrorField = currentValue(fieldNames);

        return _addError(new DIsUnique(fieldNames, options), "_isUnique", compact("errorField", "message"));
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
     * string[]|string fieldName The field or list of fields to check for existence by
     * primary key lookup in the other table.
     * @param \ORM\Table|\ORM\Association|string mytable The table name where the fields existence will be checked.
     * @param Json[string]|string errorMessage The error message to show in case the rule does not pass. Can
     * also be an array of options. When an array, the "message" key can be used to provide a message.
     */
    DRuleInvoker existsIn(
        string[] fieldName,
        Table|Association|string mytable,
        string[] errorMessage = null
   ) {
        options = null;
        if (errorMessage.isArray) {
            options = errorMessage ~ ["message": Json(null)];
            errorMessage = options.get("message"];
            options.remove("message");
        }
        if (!errorMessage) {
            errorMessage = _useI18n
                ? __d("uim", "This value does not exist")
                : "This value does not exist";
        }
        myerrorField = isString(fieldName) ? fieldName : currentValue(fieldName);

        return _addError(new DExistsIn(fieldName, mytable, options), "_existsIn", compact("errorField", "message"));
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
     * Params:
     * \ORM\Association|string myassociation The association to check for links.
     * @param string fieldName The name of the association property. When supplied, this is the name used to set
     * possible errors. When absent, the name is inferred from `myassociation`.
     * @param string errorMessage The error message to show in case the rule does not pass.
     */
    RuleInvoker isLinkedTo(
        Association|string myassociation,
        string fieldName = null,
        string errorMessage = null
   ) {
        return _addLinkConstraintRule(
            myassociation,
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
     * Params:
     * \ORM\Association|string myassociation The association to check for links.
     * @param string fieldName The name of the association property. When supplied, this is the name used to set
     * possible errors. When absent, the name is inferred from `myassociation`.
     */
    RuleInvoker isNotLinkedTo(
        Association|string myassociation,
        string fieldName = null,
        string errorMessage = null
   ) {
        return _addLinkConstraintRule(
            myassociation,
            fieldName,
            errorMessage,
            LinkConstraint.STATUS_NOT_LINKED,
            "_isNotLinkedTo"
       );
    }
    
    /**
     * Adds a link constraint rule.
     * Params:
     * \ORM\Association|string myassociation The association to check for links.
     * @param string myerrorField The name of the property to use for setting possible errors. When absent,
     * the name is inferred from `myassociation`.
     * @param string mylinkStatus The ink status required for the check to pass.
     */
    protected DRuleInvoker _addLinkConstraintRule(
        /* Association| */string myassociation,
        string myerrorField,
        string errorMessage,
        string mylinkStatus,
        string ruleName
   ) {
        if (cast(DAssociation)myassociation) {
            myassociationAlias = myassociation.name;
            myerrorField ??= myassociation.getProperty();
        } else {
            myassociationAlias = myassociation;

            if (myerrorField.isNull) {
                myrepository = _options.get("repository", null;
                if (cast(Table)myrepository) {
                    myassociation = myrepository.getAssociation(myassociation);
                    myerrorField = myassociation.getProperty();
                } else {
                    myerrorField = Inflector.underscore(myassociation);
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
            myassociation,
            mylinkStatus
       );

        return _addError(myrule, ruleName, compact("errorField", "message"));
    }
    
    /**
     * Validates the count of associated records.
     * Params:
     * string fieldName The field to check the count on.
     * @param int mycount The expected count.
     * @param string myoperator The operator for the count comparison.
     */
    RuleInvoker validCount(
        string fieldName,
        int mycount = 0,
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
