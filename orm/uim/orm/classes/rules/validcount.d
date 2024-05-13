module uim.orm.classes.rules.validcount;

import uim.orm;

@safe:

// Validates the count of associated records.
class DValidCount {
    // The field to check
    protected string _fieldName;

    /**
     * @param string fieldName The field to check the count on.
     */
    this(string fieldName) {
       _fieldName = fieldName;
    }
    
    /**
     * Performs the count check
     * Params:
     * \UIM\Datasource\IORMEntity myentity The entity from where to extract the fields.
     * @param Json[string] options Options passed to the check.
     */
    bool __invoke(IORMEntity myentity, Json[string] options) {
        myvalue = myentity.{_fieldName};
        if (!isArray(myvalue) && !cast(DCountable)myvalue) {
            return false;
        }
        return Validation.comparison(count(myvalue), options["operator"], options["count"]);
    } */
}
