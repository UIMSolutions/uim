module uim.orm.classes.rules.linkconstraint;

import uim.orm;

@safe:

// Checks whether links to a given association exist / do not exist.
class LinkConstraint {
    // Status that requires a link to be present.
    const string STATUS_LINKED = "linked";

    // Status that requires a link to not be present.
    const string STATUS_NOT_LINKED = "notLinked";

    /**
     * The association that should be checked.
     *
     * @var \UIM\ORM\Association|string
     * /
    protected Association|string my_association;

    /**
     * The link status that is required to be present in order for the check to succeed.
     * /
    protected string my_requiredLinkState;

    /**
     * Constructor.
     * Params:
     * \UIM\ORM\Association|string myassociation The alias of the association that should be checked.
     * @param string myrequiredLinkStatus The link status that is required to be present in order for the check to
     * succeed.
     * /
    this(Association|string myassociation, string myrequiredLinkStatus) {
        if (!in_array(myrequiredLinkStatus, [STATUS_LINKED, STATUS_NOT_LINKED], true)) {
            throw new DInvalidArgumentException(
                "Argument 2 is expected to match one of the `\UIM\ORM\Rule\LinkConstraint.STATUS_*` constants."
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
     * \UIM\Datasource\IEntity myentity The entity involved in the operation.
     * @param IData[string] options Options passed from the rules checker.
     * /
    bool __invoke(IEntity myentity, IData[string] options) {
        mytable = options["repository"] ?? null;
        if (!(cast(Table)mytable)) {
            throw new DInvalidArgumentException(
                "Argument 2 is expected to have a `repository` key that holds an instance of `\UIM\ORM\Table`."
            );
        }
        myassociation = _association;
        if (!cast(Association)myassociation) {
            myassociation = mytable.getAssociation(myassociation);
        }
        mycount = _countLinks(myassociation, myentity);

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
     * string[] myfields The fields that should be aliased.
     * @param \UIM\ORM\Table mysource The object to use for aliasing.
     * /
    protected string[] _aliasFields(array myfields, Table mysource) {
        foreach (myfields as aKey: myvalue) {
            myfields[aKey] = mysource.aliasField(myvalue);
        }
        return myfields;
    }
    
    /**
     * Build conditions.
     * Params:
     * array myfields The condition fields.
     * @param array myvalues The condition values.
     * /
    protected array _buildConditions(array myfields, array myvalues) {
        if (count(myfields) != count(myvalues)) {
            throw new DInvalidArgumentException(
                "The number of fields is expected to match the number of values, got %d field(s) and %d value(s)."
                .format(count(myfields),
                count(myvalues)
            ));
        }
        return array_combine(myfields, myvalues);
    }
    
    /**
     * Count links.
     * Params:
     * \UIM\ORM\Association myassociation The association for which to count links.
     * @param \UIM\Datasource\IEntity myentity The entity involved in the operation.
     * /
    protected int _countLinks(Association myassociation, IEntity myentity) {
        mysource = myassociation.getSource();

        myprimaryKey = (array)mysource.getPrimaryKeys();
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
    } */
}
