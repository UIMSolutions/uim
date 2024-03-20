module uim.orm.Rule;

import uim.orm;

@safe:

// Validates the count of associated records.
class ValidCount {
    // The field to check
    protected string my_field;

    /**
     * @param string myfield The field to check the count on.
     */
    this(string myfield) {
       _field = myfield;
    }
    
    /**
     * Performs the count check
     * Params:
     * \UIM\Datasource\IEntity myentity The entity from where to extract the fields.
     * @param IData[string] options Options passed to the check.
     */
    bool __invoke(IEntity myentity, IData[string] options) {
        myvalue = myentity.{_field};
        if (!isArray(myvalue) && !cast(Countable)myvalue) {
            return false;
        }
        return Validation.comparison(count(myvalue), options["operator"], options["count"]);
    }
}
