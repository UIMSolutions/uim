/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.rules;

import uim.orm;

@safe:

/**
 * Checks whether links to a given association exist / do not exist.
 */
class DLinkConstraint
{
    /**
     * Status that requires a link to be present.
     */
    const string STATUS_LINKED = "linked";

    /**
     * Status that requires a link to not be present.
     */
    const string STATUS_NOT_LINKED = "notLinked";

    /**
     * The association that should be checked.
     *
     * @var DORMAssociation|string
     */
    protected _association;

    /**
     * The link status that is required to be present in order for the check to succeed.
     */
    protected string _requiredLinkState;

    /**
     * Constructor.
     *
     * @param DORMAssociation|string association The alias of the association that should be checked.
     * @param string requiredLinkStatus The link status that is required to be present in order for the check to
     *  succeed.
     */
    this(association, string requiredLinkStatus) {
        if (
            !association.isString &&
            !(cast(IAssiciation)association)
        ) {
            throw new \InvalidArgumentException(sprintf(
                "Argument 1 is expected to be of type `DORMAssociation|string`, `%s` given.",
                getTypeName(association)
            ));
        }

        if (!in_array(requiredLinkStatus, [STATUS_LINKED, STATUS_NOT_LINKED], true)) {
            throw new \InvalidArgumentException(
                "Argument 2 is expected to match one of the `DORMrules.LinkConstraint::STATUS_*` constants."
            );
        }

        _association = association;
        _requiredLinkState = requiredLinkStatus;
    }

    /**
     * Callable handler.
     *
     * Performs the actual link check.
     *
     * @param DORMDatasource\IEntity anEntity The entity involved in the operation.
     * @param array<string, mixed> options Options passed from the rules checker.
     * @return bool Whether the check was successful.
     */
    bool __invoke(IEntity anEntity, IData[string] optionData) {
        table = options["repository"] ?? null;
        if (!(table instanceof DORMTable)) {
            throw new \InvalidArgumentException(
                "Argument 2 is expected to have a `repository` key that holds an instance of `DORMTable`."
            );
        }

        association = _association;
        if (!association instanceof Association) {
            association = table.getAssociation(association);
        }

        count = _countLinks(association, entity);

        if (
            (
                _requiredLinkState == STATUS_LINKED &&
                count < 1
            ) ||
            (
                _requiredLinkState == STATUS_NOT_LINKED &&
                count != 0
            )
        ) {
            return false;
        }

        return true;
    }

    /**
     * Alias fields.
     *
     * @param array<string> fields The fields that should be aliased.
     * @param DORMDORMTable source The object to use for aliasing.
     * @return array<string> The aliased fields
     */
    protected string[] _aliasFields(array fields, DORMTable source) {
        foreach (fields as key: value) {
            fields[key] = source.aliasField(value);
        }

        return fields;
    }

    /**
     * Build conditions.
     *
     * @param array fields The condition fields.
     * @param array values The condition values.
     * @return array A conditions array combined from the passed fields and values.
     */
    protected array _buildConditions(array fields, array values) {
        if (count(fields) != count(values)) {
            throw new \InvalidArgumentException(sprintf(
                "The number of fields is expected to match the number of values, got %d field(s) and %d value(s).",
                count(fields),
                count(values)
            ));
        }

        return array_combine(fields, values);
    }

    /**
     * Count links.
     *
     * @param DORMDORMAssociation anAssociation The association for which to count links.
     * @param DORMDatasource\IEntity anEntity The entity involved in the operation.
     * @return int The number of links.
     */
    protected int _countLinks(DORMAssociation anAssociation, IEntity anEntity) {
        source = association.getSource();

        primaryKeys = (array)source.getPrimaryKeys();
        if (!entity.has(primaryKeys)) {
            throw new \RuntimeException(sprintf(
                "LinkConstraint rule on `%s` requires all primary key values for building the counting " ~
                "conditions, expected values for `(%s)`, got `(%s)`.",
                source.aliasName(),
                implode(", ", primaryKeys),
                implode(", ", entity.extract(primaryKeys))
            ));
        }

        aliasedPrimaryKey = _aliasFields(primaryKeys, source);
        conditions = _buildConditions(
            aliasedPrimaryKey,
            entity.extract(primaryKeys)
        );

        return source
            .find()
            .matching(association.getName())
            .where(conditions)
            .count();
    }
}
