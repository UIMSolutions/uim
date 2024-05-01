module uim.orm.classes.rules.validcount;

import uim.orm;

@safe:

// Validates the count of associated records.
class DValidCount {
    // The field to check
    protected string _fieldName;

    /**
     * @param string myfield The field to check the count on.
     * /
    this(string myfield) {
       _fieldName = myfield;
    }
    
    /**
     * Performs the count check
     * Params:
     * \UIM\Datasource\IEntity myentity The entity from where to extract the fields.
     * @param Json[string] options Options passed to the check.
     * /
    bool __invoke(IEntity myentity, Json[string] options) {
        myvalue = myentity.{_fieldName};
        if (!isArray(myvalue) && !cast(DCountable)myvalue) {
            return false;
        }
        return Validation.comparison(count(myvalue), options["operator"], options["count"]);
    } */
}
