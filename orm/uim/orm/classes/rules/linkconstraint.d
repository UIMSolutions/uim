module uim.orm.classes.rules.linkconstraint;

import uim.orm;

@safe:

// Checks whether links to a given association exist / do not exist.
class DLinkConstraint {
    // Status that requires a link to be present.
    const string STATUS_LINKED = "linked";

    // Status that requires a link to not be present.
    const string STATUS_NOT_LINKED = "notLinked";

    // The association that should be checked.
    protected /* IAssociation| */string _association;

    // The link status that is required to be present in order for the check to succeed.
    protected string _requiredLinkState;

    this(/* Association| */string myassociation, string requiredLinkStatus) {
        if (!isIn(requiredLinkStatus, [STATUS_LINKED, STATUS_NOT_LINKED], true)) {
            /* throw new DInvalidArgumentException(
                "Argument 2 is expected to match one of the `\ORM\Rule\LinkConstraint.STATUS_*` constants."
           ); */
        }
       _association = myassociation;
       _requiredLinkState = requiredLinkStatus;
    }
    
    /**
     * Callable handler.
     *
     * Performs the actual link check.
     */
    bool __invoke(IORMEntity ormEntity, Json[string] options = null) {
        auto mytable = options.get("repository", null);
        if (!(cast(Table)mytable)) {
           /*  throw new DInvalidArgumentException(
                "Argument 2 is expected to have a `repository` key that holds an instance of `\ORM\Table`."
           ); */
        }
        auto myassociation = _association;
        if (!cast(DAssociation)myassociation) {
            myassociation = mytable.getAssociation(myassociation);
        }

        auto mycount = _countLinks(myassociation, ormEntity);
        if ((_requiredLinkState == STATUS_LINKED && mycount < 1) ||
            (_requiredLinkState == STATUS_NOT_LINKED && mycount != 0)) {
            return false;
        }
        return true;
    }
    
    // Alias fields.
    protected string[] _aliasFields(Json[string] fieldNames, Table sourceTable) {
        return fieldNames.byKeyValue.each!(kv => fieldNames[kv.key] = sourceTable.aliasField(kv.value));
    }
    
    // Build conditions.
    protected Json[string] _buildConditions(Json[string] fieldNames, Json[string] myvalues) {
        if (count(fieldNames) != count(myvalues)) {
            throw new DInvalidArgumentException(
                "The number of fields is expected to match the number of values, got %d field(s) and %d value(s)."
                .format(count(fieldNames),
                count(myvalues)
           ));
        }
        return fieldNames.combine(myvalues);
    }
    
    // Count links.
    protected int _countLinks(DAssociation association, IORMEntity ormEntity) {
        auto associationSource = association.source();
        /* auto primaryKeys = mysource.primaryKeys();
        if (!myentity.has(myprimaryKey)) {
            throw new DatabaseException(
                "LinkConstraint rule on `%s` requires all primary key values for building the counting " .
                "conditions, expected values for `(%s)`, got `(%s)`."
                .format(mysource.aliasName(),
                primaryKeys.join(", "),
                myentity.extract(primaryKeys).join(", ")
           ));
        }
        myaliasedPrimaryKey = _aliasFields(primaryKeys, associationSource);
        myconditions = _buildConditions(
            myaliasedPrimaryKey,
            myentity.extract(primaryKeys)
       );

        return mysource
            .find()
            .matching(association.name)
            .where(myconditions)
            .count(); */
        return 0;
    }
}
