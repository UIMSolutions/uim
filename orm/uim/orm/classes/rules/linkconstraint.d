module uim.orm.classes.rules.linkconstraint;

import uim.orm;

@safe:

// Checks whether links to a given association exist / do not exist.
class DLinkConstraint {
    // Status that requires a link to be present.
    const string STATUS_LINKED = "linked";

    // Status that requires a link to not be present.
    const string STATUS_NOT_LINKED = "notLinked";

    /**
     * The association that should be checked.
     *
     * @var \ORM\Association|string
     */
    protected IAssociation|string _association;

    // The link status that is required to be present in order for the check to succeed.
    protected string _requiredLinkState;

    /**
     .
     * Params:
     * \ORM\Association|string myassociation The alias of the association that should be checked.
     * @param string myrequiredLinkStatus The link status that is required to be present in order for the check to
     * succeed.
     */
    this(Association|string myassociation, string myrequiredLinkStatus) {
        if (!isIn(myrequiredLinkStatus, [STATUS_LINKED, STATUS_NOT_LINKED], true)) {
            throw new DInvalidArgumentException(
                "Argument 2 is expected to match one of the `\ORM\Rule\LinkConstraint.STATUS_*` constants."
           );
        }
       _association = myassociation;
       _requiredLinkState = myrequiredLinkStatus;
    }
    
    /**
     * Callable handler.
     *
     * Performs the actual link check.
     * Params:
     * \UIM\Datasource\IORMEntity myentity The entity involved in the operation.
     * @param Json[string] options Options passed from the rules checker.
     */
    bool __invoke(IORMEntity myentity, Json[string] options) {
        auto mytable = options.get("repository", null);
        if (!(cast(Table)mytable)) {
            throw new DInvalidArgumentException(
                "Argument 2 is expected to have a `repository` key that holds an instance of `\ORM\Table`."
           );
        }
        auto myassociation = _association;
        if (!cast(DAssociation)myassociation) {
            myassociation = mytable.getAssociation(myassociation);
        }

        auto mycount = _countLinks(myassociation, myentity);
        if (
            (
               _requiredLinkState == STATUS_LINKED &&
                mycount < 1
           ) ||
            (
               _requiredLinkState == STATUS_NOT_LINKED &&
                mycount != 0
           )
       ) {
            return false;
        }
        return true;
    }
    
    /**
     * Alias fields.
     * Params:
     * string[] fieldNames The fields that should be aliased.
     * @param \ORM\Table mysource The object to use for aliasing.
     */
    protected string[] _aliasFields(Json[string] fieldNames, Table mysource) {
        foreach (fieldNames as aKey: myvalue) {
            fieldNames[aKey] = mysource.aliasField(myvalue);
        }
        return fieldNames;
    }
    
    /**
     * Build conditions.
     * Params:
     * Json[string] fieldNames The condition fields.
     * @param Json[string] myvalues The condition values.
     */
    protected Json[string] _buildConditions(Json[string] fieldNames, Json[string] myvalues) {
        if (count(fieldNames) != count(myvalues)) {
            throw new DInvalidArgumentException(
                "The number of fields is expected to match the number of values, got %d field(s) and %d value(s)."
                .format(count(fieldNames),
                count(myvalues)
           ));
        }
        return array_combine(fieldNames, myvalues);
    }
    
    /**
     * Count links.
     * Params:
     * \ORM\Association myassociation The association for which to count links.
     * @param \UIM\Datasource\IORMEntity myentity The entity involved in the operation.
     */
    protected int _countLinks(Association myassociation, IORMEntity myentity) {
        mysource = myassociation.source();

        myprimaryKey = (array)mysource.primaryKeys();
        if (!myentity.has(myprimaryKey)) {
            throw new DatabaseException(
                "LinkConstraint rule on `%s` requires all primary key values for building the counting " .
                "conditions, expected values for `(%s)`, got `(%s)`."
                .format(mysource.aliasName(),
                join(", ", myprimaryKey),
                join(", ", myentity.extract(myprimaryKey))
           ));
        }
        myaliasedPrimaryKey = _aliasFields(myprimaryKey, mysource);
        myconditions = _buildConditions(
            myaliasedPrimaryKey,
            myentity.extract(myprimaryKey)
       );

        return mysource
            .find()
            .matching(myassociation.name)
            .where(myconditions)
            .count();
    }
}
