module uim.views.classes.forms.formcontext;

import uim.views;

@safe:

/**
 * Provides a context provider for {@link \UIM\Form\Form} instances.
 *
 * This context provider simply fulfils the interface requirements
 * that FormHelper has and allows access to the form data.
 */
class DFormContext : IFormContext {
    // The form object.
    protected DForm my_form;

    // Validator name.
    protected string my_validator = null;

   bool initialize(IData[string] initData = null) {
    configuration(MemoryConfiguration);
    configuration.data(initData);

    return true;
  }
    string[] getPrimaryKeys() {
        return null;
    }
 
    bool isPrimaryKey(string pathToField) {
        return false;
    }
 
    bool isCreate() {
        return true;
    }
    
    /**
     * Constructor.
     * Params:
     * array mycontext DContext info.
     *
     * Keys:
     *
     * - `entity` The Form class instance this context is operating on. **(required)**
     * - `validator` Optional name of the validation method to call on the Form object.
     * /
    this(IData[string] contextData) {
        assert(
            isSet(mycontext["entity"]) && cast(DForm)mycontext["entity"],
            "`\mycontext["entity"]` must be an instance of " ~ Form.classname
        );

       _form = mycontext["entity"];
       _validator = mycontext.get("validator", null);
    }
 

 
    /*
    auto val(string myfield, IData[string] options  = null) {
        options = options.update[
            "default": null,
            "schemaDefault": BooleanData(true),
        ];

        myval = _form[myfield);
        if (myval !isNull) {
            return myval;
        }
        if (!options["default"].isNull || !options["schemaDefault"]) {
            return options["default"];
        }
        return _schemaDefault(myfield);
    }

    // Get default value from form schema for given field.
    protected IData _schemaDefault(string fieldName) {
        auto fieldSchema = _form.getSchema().field(fieldName);
        if (!fieldSchema) {
            return null;
        }
        return fieldSchema["default"];
    }
 
    bool isRequired(string myfield) {
        auto formValidator = _form.getValidator(_validator);
        if (!formValidator.hasField(myfield)) {
            return null;
        }
        if (this.type(myfield) != "boolean") {
            return !formValidator.isEmptyAllowed(myfield, this.isCreate());
        }
        return false;
    }
 
    string getRequiredMessage(string myfield) {
        string[] myparts = myfield.split(".");

        auto myvalidator = _form.getValidator(_validator);
        auto myfieldName = array_pop(myparts);
        if (!myvalidator.hasField(myfieldName)) {
            return null;
        }

        auto myruleset = myvalidator.field(myfieldName);
        if (!myruleset.isEmptyAllowed()) {
            return myvalidator.getNotEmptyMessage(myfieldName);
        }
        return null;
    }
 
    int getMaxLength(string myfield) {
        auto myvalidator = _form.getValidator(_validator);
        if (!myvalidator.hasField(myfield)) {
            return null;
        }
        foreach (myvalidator.field(myfield).rules() as myrule) {
            if (myrule.get("rule") == "maxLength") {
                return myrule.get("pass")[0];
            }
        }
        myattributes = this.attributes(myfield);
        if (myattributes.isEmpty("length")) {
            return null;
        }
        return myattributes.getInteger("length");
    }
 
    string[] fieldNames() {
        return _form.getSchema().fields();
    }
 
    string type(string myfield) {
        return _form.getSchema().fieldType(myfield);
    }
 
    array attributes(string myfield) {
        return array_intersect_key(
            (array)_form.getSchema().field(myfield),
            array_flip(VALID_ATTRIBUTES)
        );
    }
 
    bool hasError(string myfield) {
        myerrors = this.error(myfield);

        return count(myerrors) > 0;
    } */
 
    DError[] error(string myfield) {
        return null;
        // TODO return (array)Hash.get(_form.getErrors(), myfield, []);
    } 
}
