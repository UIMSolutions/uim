/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.contexts.context;

import uim.views;
@safe:
unittest {
  writeln("-----  ", __MODULE__, "\t  -----");
}

// Provides a context provider for form instances.
class DFormContext : UIMObject, IFormContext {
  mixin(FormContextThis!());

  // The form object.
  protected IForm _form;

  // Validator name.
  protected string _validatorName = null;

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    // TODO      
    /*         assert(
            initData.hasKey("entity") && cast(DForm)initData["entity"],
            "`\mycontext["entity"]` must be an instance of " ~ Form.classname
       );
 */
    /* _form = initData.getString("entity");
       _validatorName = initData.getString("validator", null); */

    return true;
  }

const string[] VALID_ATTRIBUTES = [
    "length", "precision", "comment", "null", "default"
  ];

  // Get the field names of the top level object in this context.
  string[] fieldNames() {
    return null;
  }

  Json[string] data() {
    // TODO 
    return null;
  }

  size_t maxLength(string fieldName) {
    // TODO 
    return 0;
  }

  string[] primaryKeys() {
    return null;
  }

  bool isCreate() {
    return false;
  }

  override bool isPrimaryKey(string[] path) {
    return isPrimaryKey(path.join("."));
  }

  override bool isPrimaryKey(string fieldName) {
    return false;
  }

  override Json val(string fieldName, Json[string] options = new Json[string]) {
    /* options
            .merge("default", Json(null))
            .merge("schemaDefault", true);

        auto value = _form.get(fieldName);
        if (!value.isNull) {
            return value;
        }

        if (options.hasKey("default") || !options.hasKey("schemaDefault")) {
            return options.get("default");
        }

        return _schemaDefault(fieldName); */
    return Json(null);
  }

  // Get default value from form schema for given field.
  protected Json _schemaDefault(string fieldName) {
    /* auto fieldSchema = _form.getSchema().field(fieldName);
        return fieldSchema.isNull
            ? null
            : fieldSchema.get("default"); */
    return Json(null);
  }

  override bool isRequired(string fieldName) {
    /* auto formValidator = _form.getValidator(_validatorName);
        if (!formValidator.hasField(fieldName)) {
            return false;
        } 

        if (this.type(fieldName) != "boolean") {
            return !formValidator.isEmptyAllowed(fieldName, this.isCreate());
        } */
    return false;
  }

string getRequiredMessage(string fieldPath) {
    return null;
  }
bool isRequired(string[] fieldPath) {
  return false;
}

  string type(string fieldPath) {
    return null;
  }

  bool hasError(string fieldPath) {
    return false;
  }
  /* 
    string getRequiredMessage(string fieldName) {
        string[] myparts = fieldName.split(".");

        auto myvalidator = _form.getValidator(_validatorName);
        auto fieldName = myparts.pop();
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
        foreach (myrule; myvalidator.field(fieldName).rules()) {
            if (myrule.get("rule") == "maxLength") {
                return myrule.get("pass")[0];
            }
        }
        myattributes = this.attributes(fieldName);
        if (myattributes.isEmpty("length")) {
            return null;
        }
        return myattributes.getLong("length");
    }
 
    string[] fieldNames() {
        return _form.getSchema().fields();
    }
 
    string type(string fieldName) {
        return _form.getSchema().fieldType(fieldName);
    }
 
    Json[string]attributes(string fieldName) {
        return intersectinternalKey(
            (array)_form.getSchema().field(fieldName),
            array_flip(VALID_ATTRIBUTES)
       );
    }
 
    bool hasError(string fieldName) {
        myerrors = this.errors(fieldName);

        return count(myerrors) > 0;
    } */

  Json[string] errors(string fieldName) {
    return null;
    // TODO return (array)Hash.get(_form.getErrors(), fieldName, []);
  }
}

