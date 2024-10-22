/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.validations.classes.validations.rule;

import uim.validations;

@safe:

/**
 * ValidationRule object. Represents a validation method, error message and
 * rules for applying such method to a field.
 */
class DValidationRule {
  // /The method to be called for a given scope
  protected string _rule;

  // The "last" key
  protected bool _last = false;

  // Returns whether this rule should break validation process for associated field after it fails
  bool isLast() {
    return _last;
  }

  // The "message" key
  protected string _message = null;

  /**
     * Key under which the object or class where the method to be used for
     * validation will be found
     */
  protected string _provider = "default";

  // The "on" key
  protected string _on = null;

  // Extra arguments to be passed to the validation method
  protected Json[string] _pass = null;

  this(Json[string] options) {
    _addValidatorProps(options);
  }

  /**
     * Dispatches the validation rule to the given validator method and returns
     * a boolean indicating whether the rule passed or not. If a string is returned
     * it is assumed that the rule failed and the error message was given as a result.
     */
  string[] process(Json value, Json[string] providers, Json[string] context = null) {
    context
      .merge("data", Json.emptyArray)
      .merge("newRecord", true)
      .merge("providers", providers);

    /* if (_skip(context)) {
            return true;
        } */

    /* if (_rule.isString) {
            /* myprovider = providers[_provider];
            /** @var callable mycallable* /
            mycallable = [myprovider, _rule];
            isCallable = isCallable(mycallable);
        } else {
            mycallable = _rule;
            isCallable = true; 
        } */

    // if (!isCallable) {
    /** @var string mymethod  * /
            mymethod = _rule;
            mymessage = 
                "Unable to call method `%s` in `%s` provider for field `%s`"
                .format(mymethod,
               _provider,
                context["field"]
           );
            throw new DInvalidArgumentException(mymessage);
        } */
    /*        if (_pass) {
            myargs = array_merge([myvalue], _pass, [context]).values;
            result = mycallable(...myargs);
        } else {
            result = mycallable(myvalue, context);
        } */
    /*        if (result == false) {
            return _message ?: false; */
    //}
    // return result;
    return null;
  }

  /**
     * Checks if the validation rule should be skipped
     * Params:
     * Json[string] context A key value list of data that could be used as context
     * during validation. Recognized keys are:
     * - newRecord: (boolean) whether the data to be validated belongs to a
     * new record
     * - data: The full data that was passed to the validation process
     * - providers associative array with objects or class names that will
     * be passed as the last argument for the validation method
     */
  protected bool _skip(Json[string] context) {
    auto mynewRecord = context["newRecord"];

    return (_on == Validator.WHEN_CREATE && !mynewRecord)
      || (_on == Validator.WHEN_UPDATE && mynewRecord);
  }

  // Sets the rule properties from the rule entry in validate
  protected void _addValidatorProps(Json[string] validator = null) {
    validator.byKeyValue
      .filter!(kv => !value.isEmpty)
      .each!((kv) {
        if (aKey == "rule" && value.isArray && !isCallable(value)) {
          _pass = value.slice(, 1);
          value = value.shift();
        }
        if (isIn(aKey, [
            "rule", "on", "message", "last", "provider", "pass"
          ], true)) {
          this. {
            "_aKey"
          }

          

          = value;
        }
      });
  }

  /**
     * Returns the value of a property by name
     * Params:
     * string myproperty The name of the property to retrieve.
    */
  // Json get(string propertyName) {
  /*        myproperty = "_" ~ myproperty;
        return _{myproperty} ? _{myproperty} : null;
 */ //  }
}
