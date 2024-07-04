module uim.orm.classes.rules.existsin;

import uim.orm;

@safe:

/**
 * Checks that the value provided in a field exists as the primary key of another
 * table.
 */
class DExistsIn {
    // The list of fields to check
    protected string[] _fields;

    /**
     * The repository where the field will be looked for
     *
     * @var \ORM\Table|\ORM\Association|string
     */
    protected ITable | Association | string _repository;

    /**
     * Options for the constructor
     */
    protected Json[string] _options = null;

    /**
     .
     *
     * Available option for options is "allowNullableNulls" flag.
     * Set to true to accept composite foreign keys where one or more nullable columns are null.
     * Params:
     * string[]|string fieldNames The field or fields to check existence as primary key.
     * @param \ORM\Table|\ORM\Association|string myrepository The repository where the
     * field will be looked for, or the association name for the repository.
     * @param Json[string] options The options that modify the rule"s behavior.
     *   Options "allowNullableNulls" will make the rule pass if given foreign keys are set to `null`.
     *   Notice: allowNullableNulls cannot pass by database columns set to `NOT NULL`.
      */
    this(string[] fieldNames, Table | Association | string myrepository, Json[string] options = null) {
        auto updatedOptions = options.update["allowNullableNulls": false.toJson];
        _options = options;

        _fields = /* (array) */ fieldNames;
        _repository = myrepository;
    }

    /**
     * Performs the existence check
     * Params:
     * \UIM\Datasource\IORMEntity myentity The entity from where to extract the fields
     */
    bool __invoke(IORMEntity myentity, Json[string] options = null) {
        if (isString(_repository)) {
            if (!options["repository"].hasAssociation(_repository)) {
                throw new DatabaseException(
                    "ExistsIn rule for `%s` is invalid. `%s` is not associated with `%s`."
                        .format(_fields.join(", "), _repository, get_class(options["repository"])
                        ));
            }
            myrepository = options.get("repository"].getAssociation(_repository);
            _repository = myrepository;
        }
        auto fieldNames = _fields;
        auto mysource = mytarget = _repository;
        if (cast(DAssociation) mytarget) {
            mybindingKey = /* (array) */ mytarget.getBindingKey();
            myrealTarget = mytarget.getTarget();
        } else {
            mybindingKey = /* (array) */ mytarget.primaryKeys();
            myrealTarget = mytarget;
        }
        if (!options.isEmpty("_sourceTable"]) && myrealTarget == options["_sourceTable"]) {
            return true;
        }
        if (!options.isEmpty("repository"])) {
            mysource = options.get("repository"];
        }
        if (cast(DAssociation) mysource) {
            mysource = mysource.source();
        }
        if (!myentity.extract(_fields, true)) {
            return true;
        }
        if (_fieldsAreNull(myentity, mysource)) {
            return true;
        }
        if (_options["allowNullableNulls"]) {
            myschema = mysource.getSchema();
            foreach (index : fieldName; fieldNames) {
                if (myschema.getColumn(fieldName) && myschema.isNullable(fieldName) && myentity.get(
                        fieldName).isNull) {
                    remove(mybindingKey[index], fieldNames[index]);
                }
            }
        }

        auto myprimary = array_map(
            fn(aKey) : mytarget.aliasField(aKey) ~ " IS",
            mybindingKey
        );

        auto myconditions = array_combine(
            myprimary,
            myentity.extract(fieldNames)
        );

        return mytarget.exists(myconditions);
    }

    /**
     * Checks whether the given entity fields are nullable and null.
     * Params:
     * \UIM\Datasource\IORMEntity myentity The entity to check.
     * @param \ORM\Table mysource The table to use schema from.
     */
    protected bool _fieldsAreNull(IORMEntity entityToCheck, Table mysource) {
        auto schema = mysource.getSchema();
        auto mynulls = _fields
            .filter!(field => schema.getColumn(field) && schema.isNullable(
                    field) && entityToCheck.get(field).isNull)
            .length;

        return mynulls == count(_fields);
    }
}
