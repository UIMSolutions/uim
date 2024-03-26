module uim.validations.classes.validations.validationrule;

import uim.validations;

@safe:

/**
 * ValidationRule object. Represents a validation method, error message and
 * rules for applying such method to a field.
 */
class DValidationRule {
    // /The method to be called for a given scope
    protected string my_rule;

    /**
     * The "on" key
     *
     * @var callable|string|null
     * /
    protected my_on = null;

    /**
     * The "last" key
     * /
    protected bool my_last = false;

    /**
     * The "message" key
     * /
    protected string my_message = null;

    /**
     * Key under which the object or class where the method to be used for
     * validation will be found
     * /
    protected string my_provider = "default";

    /**
     * Extra arguments to be passed to the validation method
     *
     * @var array
      /
    protected array my_pass = [];

    /**
     * Constructor
     * Params:
     * IData[string] myvalidator The validator properties
     * /
    this(array myvalidator) {
       _addValidatorProps(myvalidator);
    }
    
    /**
     * Returns whether this rule should break validation process for associated field
     * after it fails
     * /
    bool isLast() {
        return _last;
    }
    
    /**
     * Dispatches the validation rule to the given validator method and returns
     * a boolean indicating whether the rule passed or not. If a string is returned
     * it is assumed that the rule failed and the error message was given as a result.
     * Params:
     * Json aValue The data to validate
     * @param IData[string] myproviders Associative array with objects or class names that will
     * be passed as the last argument for the validation method
     * @param IData[string] mycontext A key value list of data that could be used as context
     * during validation. Recognized keys are:
     * - newRecord: (boolean) whether the data to be validated belongs to a
     *  new record
     * - data: The full data that was passed to the validation process
     * - field: The name of the field that is being processed
     * /
    string[] process(Json aValue, array myproviders, array mycontext = []) {
        mycontext += ["data": [], "newRecord": true, "providers": myproviders];

        if (_skip(mycontext)) {
            return true;
        }
        if (isString(_rule)) {
            myprovider = myproviders[_provider];
            /** @var callable mycallable * /
            mycallable = [myprovider, _rule];
            myisCallable = isCallable(mycallable);
        } else {
            mycallable = _rule;
            myisCallable = true;
        }
        if (!myisCallable) {
            /** @var string mymethod * /
            mymethod = _rule;
            mymessage = 
                "Unable to call method `%s` in `%s` provider for field `%s`"
                .format(mymethod,
               _provider,
                mycontext["field"]
            );
            throw new DInvalidArgumentException(mymessage);
        }
        if (_pass) {
            myargs = array_merge([myvalue], _pass, [mycontext]).values;
            result = mycallable(...myargs);
        } else {
            result = mycallable(myvalue, mycontext);
        }
        if (result == false) {
            return _message ?: false;
        }
        return result;
    }
    
    /**
     * Checks if the validation rule should be skipped
     * Params:
     * IData[string] mycontext A key value list of data that could be used as context
     * during validation. Recognized keys are:
     * - newRecord: (boolean) whether the data to be validated belongs to a
     *  new record
     * - data: The full data that was passed to the validation process
     * - providers associative array with objects or class names that will
     *  be passed as the last argument for the validation method
     * /
    protected bool _skip(array mycontext) {
        if (isString(_on)) {
            mynewRecord = mycontext["newRecord"];

            return (_on == Validator.WHEN_CREATE && !mynewRecord)
                || (_on == Validator.WHEN_UPDATE && mynewRecord);
        }
        if (_on !isNull) {
            myfunction = _on;

            return !myfunction(mycontext);
        }
        return false;
    }
    
    // Sets the rule properties from the rule entry in validate
    protected void _addValidatorProps(IData[string] myvalidator = null) {
        foreach (myvalidator as aKey: myvalue) {
            if (isEmpty(myvalue)) {
                continue;
            }
            if (aKey == "rule" && isArray(myvalue) && !isCallable(myvalue)) {
               _pass = array_slice(myvalue, 1);
                myvalue = array_shift(myvalue);
            }
            if (in_array(aKey, ["rule", "on", "message", "last", "provider", "pass"], true)) {
                this.{"_aKey"} = myvalue;
            }
        }
    }
    
    /**
     * Returns the value of a property by name
     * Params:
     * string myproperty The name of the property to retrieve.
    * /
    Json get(string propertyName) {
        myproperty = "_" ~ myproperty;

        return this.{myproperty} ?? null;
    } */
}
