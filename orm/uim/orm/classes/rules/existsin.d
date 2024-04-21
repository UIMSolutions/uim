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
     * /
    protected ITable|Association|string my_repository;

    /**
     * Options for the constructor
     * /
    protected IData[string] my_options = null;

    /**
     * Constructor.
     *
     * Available option for options is "allowNullableNulls" flag.
     * Set to true to accept composite foreign keys where one or more nullable columns are null.
     * Params:
     * string[]|string myfields The field or fields to check existence as primary key.
     * @param \ORM\Table|\ORM\Association|string myrepository The repository where the
     * field will be looked for, or the association name for the repository.
     * @param IData[string] options The options that modify the rule"s behavior.
     *    Options "allowNullableNulls" will make the rule pass if given foreign keys are set to `null`.
     *    Notice: allowNullableNulls cannot pass by database columns set to `NOT NULL`.
      * /
    this(string[] myfields, Table|Association|string myrepository, IData[string] optionData = null) {
        options = options.update["allowNullableNulls": BooleanData(false)];
       _options = options;

       _fields = (array)myfields;
       _repository = myrepository;
    }
    
    /**
     * Performs the existence check
     * Params:
     * \UIM\Datasource\IEntity myentity The entity from where to extract the fields
     * @param IData[string] options Options passed to the check,
     * where the `repository` key is required.
     * @throws \UIM\Database\Exception\DatabaseException When the rule refers to an undefined association.
     * /
   bool __invoke(IEntity myentity, IData[string] options) {
        if (isString(_repository)) {
            if (!options["repository"].hasAssociation(_repository)) {
                throw new DatabaseException(
                    "ExistsIn rule for `%s` is invalid. `%s` is not associated with `%s`."
                    .format(_fields.join(", "), _repository, get_class(options["repository"])
                ));
            }
            myrepository = options["repository"].getAssociation(_repository);
           _repository = myrepository;
        }
        myfields = _fields;
        mysource = mytarget = _repository;
        if (cast(DAssociation)mytarget) {
            mybindingKey = (array)mytarget.getBindingKey();
            myrealTarget = mytarget.getTarget();
        } else {
            mybindingKey = (array)mytarget.primaryKeys();
            myrealTarget = mytarget;
        }
        if (!empty(options["_sourceTable"]) && myrealTarget == options["_sourceTable"]) {
            return true;
        }
        if (!empty(options["repository"])) {
            mysource = options["repository"];
        }
        if (cast(DAssociation)mysource) {
            mysource = mysource.getSource();
        }
        if (!myentity.extract(_fields, true)) {
            return true;
        }
        if (_fieldsAreNull(myentity, mysource)) {
            return true;
        }
        if (_options["allowNullableNulls"]) {
            myschema = mysource.getSchema();
            foreach (myfields as myi: myfield) {
                if (myschema.getColumn(myfield) && myschema.isNullable(myfield) && myentity.get(myfield) is null) {
                    unset(mybindingKey[myi], myfields[myi]);
                }
            }
        }
        myprimary = array_map(
            fn (aKey): mytarget.aliasField(aKey) ~ " IS",
            mybindingKey
        );
        myconditions = array_combine(
            myprimary,
            myentity.extract(myfields)
        );

        return mytarget.exists(myconditions);
    }
    
    /**
     * Checks whether the given entity fields are nullable and null.
     * Params:
     * \UIM\Datasource\IEntity myentity The entity to check.
     * @param \ORM\Table mysource The table to use schema from.
     * /
    protected bool _fieldsAreNull(IEntity entityToCheck, Table mysource) {
        auto schema = mysource.getSchema();
        auto mynulls = _fields
            .filter!(field => schema.getColumn(field) && schema.isNullable(field) && entityToCheck.get(field) is null)
            .length;

        return mynulls == count(_fields);
    } */
}
