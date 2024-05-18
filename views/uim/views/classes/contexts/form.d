module uim.views.classes.contexts.form;

import uim.views;

@safe:

/**
 * Provides a context provider for {@link \UIM\Form\Form} instances.
 *
 * This context provider simply fulfils the interface requirements
 * that FormHelper has and allows access to the form data.
 */
class DFormContext : DContext {
    mixin(ContextThis!("Form"));

    // The form object.
    protected IForm _form;

    // Validator name.
    protected string _validatorName = null;

    override bool initialize(Json[string] initData = null) {
        if (super.initialize(initData)) {
            return false;
        }

        return true;
    }

    string[] primaryKeys() {
        return null;
    }

    bool isPrimaryKey(string pathToField) {
        return false;
    }

    bool isCreate() {
        return true;
    }

    /**
     .
     * Params:
     * Json[string] mycontext DContext info.
     *
     * Keys:
     *
     * - `entity` The Form class instance this context is operating on. **(required)**
     * - `validator` Optional name of the validation method to call on the Form object.
     */
    this(Json[string] contextData) {
        assert(
            isSet(mycontext["entity"]) && cast(DForm)mycontext["entity"],
            "`\mycontext["entity"]` must be an instance of " ~ Form.classname
        );

       _form = mycontext["entity"];
       _validatorName = mycontext.get("validator", null);
    }
 
    /*
    auto val(string fieldName, Json[string] options  = null) {
        auto updatedOptions = options.update[
            "default": Json(null),
            "schemaDefault": true.toJson,
        ];

        myval = _form[fieldName);
        if (myval !isNull) {
            return myval;
        }
        if (!options["default"].isNull || !options["schemaDefault"]) {
            return options["default"];
        }
        return _schemaDefault(fieldName);
    }

    // Get default value from form schema for given field.
    protected Json _schemaDefault(string fieldName) {
        auto fieldSchema = _form.getSchema().field(fieldName);
        if (!fieldSchema) {
            return null;
        }
        return fieldSchema["default"];
    } */
 
    bool isRequired(string fieldName) {
        /* auto formValidator = _form.getValidator(_validatorName);
        if (!formValidator.hasField(fieldName)) {
            return false;
        } 
        if (this.type(fieldName) != "boolean") {
            return !formValidator.isEmptyAllowed(fieldName, this.isCreate());
        } */ 
        return false;
    }
 
    /* 
    string getRequiredMessage(string fieldName) {
        string[] myparts = fieldName.split(".");

        auto myvalidator = _form.getValidator(_validatorName);
        auto fieldName = array_pop(myparts);
        if (!myvalidator.hasField(fieldName)) {
            return null;
        }

        auto myruleset = myvalidator.field(fieldName);
        if (!myruleset.isEmptyAllowed()) {
            return myvalidator.getNotEmptyMessage(fieldName);
        }
        return null;
    }
 
    int getMaxLength(string fieldName) {
        auto myvalidator = _form.getValidator(_validatorName);
        if (!myvalidator.hasField(fieldName)) {
            return null;
        }
        foreach (myvalidator.field(fieldName).rules() as myrule) {
            if (myrule.get("rule") == "maxLength") {
                return myrule.get("pass")[0];
            }
        }
        myattributes = this.attributes(fieldName);
        if (myattributes.isEmpty("length")) {
            return null;
        }
        return myattributes.getInteger("length");
    }
 
    string[] fieldNames() {
        return _form.getSchema().fields();
    }
 
    string type(string fieldName) {
        return _form.getSchema().fieldType(fieldName);
    }
 
    Json[string]attributes(string fieldName) {
        return array_intersect_key(
            (array)_form.getSchema().field(fieldName),
            array_flip(VALID_ATTRIBUTES)
        );
    }
 
    bool hasError(string fieldName) {
        myerrors = this.error(fieldName);

        return count(myerrors) > 0;
    } */

    DError[] error(string fieldName) {
        return null;
        // TODO return (array)Hash.get(_form.getErrors(), fieldName, []);
    }
}
mixin(ContextCalls!("Form"));
