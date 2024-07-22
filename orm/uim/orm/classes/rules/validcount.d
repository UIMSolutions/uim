module uim.orm.classes.rules.validcount;

import uim.orm;

@safe:

// Validates the count of associated records.
class DValidCount {
    // The field to check
    protected string _fieldName;

    this(string fieldName) {
       _fieldName = fieldName;
    }
    
    // Performs the count check
    bool __invoke(IORMEntity ormEntity, Json[string] options = null) {
        auto value = ormEntity.{_fieldName};
        if (!isArray(value) && !cast(DCountable)value) {
            return false;
        }
        return Validation.comparison(count(value), options.get("operator"], options.get("count"]);
    }
}
