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

    // The repository where the field will be looked for
    protected ITable /* | Association | string */ _repository;

    // Options for the constructor
    protected Json[string] _options = null;

    /**
     * Available option for options is "allowNullableNulls" flag.
     * Set to true to accept composite foreign keys where one or more nullable columns are null.
      */
    this(string[] fieldNames, /* Table | Association | */ string myrepository, Json[string] options = null) {
        auto updatedOptions = options.setPath(["allowNullableNulls": false.toJson]);
        _options = options;

        _fields = /* (array) */ fieldNames;
        _repository = myrepository;
    }

    // Performs the existence check
    bool __invoke(IORMEntity ormEntity, Json[string] options = null) {
        if (isString(_repository)) {
            if (!options.hasKey("repository").hasAssociation(_repository)) {
                throw new DatabaseException(
                    "ExistsIn rule for `%s` is invalid. `%s` is not associated with `%s`."
                        .format(_fields.join(", "), _repository, get_class(options.get("repository"))
                        ));
            }
            myrepository = options.get("repository").getAssociation(_repository);
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
        if (options.hasKey("_sourceTable") && myrealTarget == options.get("_sourceTable")) {
            return true;
        }
        if (options.hasKey("repository")) {
            mysource = options.get("repository");
        }
        if (cast(DAssociation) mysource) {
            mysource = mysource.source();
        }
        if (!ormEntity.extract(_fields, true)) {
            return true;
        }
        if (_fieldsAreNull(ormEntity, mysource)) {
            return true;
        }
        if (_options.get("allowNullableNulls")) {
            auto myschema = mysource.getSchema();
            foreach (index, fieldName; fieldNames) {
                if (myschema.getColumn(fieldName) && myschema.isNullable(fieldName) && ormEntity.get(
                        fieldName).isNull) {
                    mybindingKey.removeKey(index);
                    fieldNames.removeKey(index);
                }
            }
        }

        /* auto myprimary = array_map(
            fn(aKey) : mytarget.aliasField(aKey) ~ " IS",
            mybindingKey
        );

        auto myconditions = myprimary.combine(myentity.extract(fieldNames));
        return mytarget.hasKey(myconditions); */
        return false;
    }

    // Checks whether the given entity fields are nullable and null.
    protected bool _fieldsAreNull(IORMEntity entityToCheck, DORMTable mysource) {
        auto schema = mysource.getSchema();
        auto mynulls = _fields
            .filter!(field => schema.getColumn(field) && schema.isNullable(
                    field) && entityToCheck.get(field).isNull)
            .length;

        return mynulls == count(_fields);
    }
}
