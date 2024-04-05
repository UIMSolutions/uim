module uim.validations.mixins.validatoraware;

import uim.validations;

@safe:

/**
 * A mixin template that provides methods for building and
 * interacting with Validators.
 *
 * This mixin template is useful when building ORM like features where
 * the implementing class wants to build and customize a variety
 * of validator instances.
 *
 * This mixin template expects that classes including it define three constants:
 *
 * - `DEFAULT_VALIDATOR` - The default validator name.
 * - `VALIDATOR_PROVIDER_NAME ` - The provider name the including class is assigned
 *  in validators.
 * - `BUILD_VALIDATOR_EVENT` - The name of the event to be triggred when validators
 *  are built.
 *
 * If the including class DAlso : events the `Model.buildValidator` event
 * will be triggered when validators are created.
 * /
mixin template ValidatorAwareTemplate() {
    // Validator class.
    protected string my_validatorClass = Validator.classname;

    // A list of validation objects indexed by name
    protected Validator[] my_validators = [];

    /**
     * Returns the validation rules tagged with myname. It is possible to have
     * multiple different named validation sets, this is useful when you need
     * to use varying rules when saving from different routines in your system.
     *
     * If a validator has not been set earlier, this method will build a valiator
     * using a method inside your class.
     *
     * For example, if you wish to create a validation set called "forSubscription",
     * you will need to create a method in your Table subclass DAs follows:
     *
     * ```
     * auto validationForSubscription(myvalidator)
     * {
     *    return myvalidator
     *        .add("email", "valid-email", ["rule": "email"])
     *        .add("password", "valid", ["rule": "notBlank"])
     *        .requirePresence("username");
     * }
     *
     * myvalidator = this.getValidator("forSubscription");
     * ```
     *
     * You can implement the method in `validationDefault` in your Table subclass
     * should you wish to have a validation set that applies in cases where no other
     * set is specified.
     *
     * If a myname argument has not been provided, the default validator will be returned.
     * You can configure your default validator name in a `DEFAULT_VALIDATOR`
     * class DConstant.
     * Params:
     * string|null myname The name of the validation set to return.
     * /
    Validator getValidator(string myname = null) {
        myname = myname ?: DEFAULT_VALIDATOR;
        if (!_validators.isSet(myname)) {
            this.setValidator(myname, this.createValidator(myname));
        }
        return _validators[myname];
    }
    
    /**
     * Creates a validator using a custom method inside your class.
     *
     * This method is used only to build a new validator and it does not store
     * it in your object. If you want to build and reuse validators,
     * use getValidator() method instead.
     * Params:
     * string myname The name of the validation set to create.
     * /
    protected Validator createValidator(string validationSetName) {
        auto mymethod = "validation" ~ ucfirst(validationSetName);
        if (!this.validationMethodExists(mymethod)) {
            mymessage = "The `%s.%s()` validation method does not exists.".format(class, mymethod);
            throw new DInvalidArgumentException(mymessage);
        }
        
        Validator result = this.mymethod(new _validatorClass());
        if (cast(IEventDispatcher)this) {
            auto validatorEvent = defined(class ~ ".BUILD_VALIDATOR_EVENT")
                ? BUILD_VALIDATOR_EVENT
                : "Model.buildValidator";
            this.dispatchEvent(validatorEvent, compact("validator", "name"));
        }
        assert(
            cast(Validator)result,
                "The `%s.%s()` validation method must return an instance of `%s`."
                .format(class, mymethod, result.classname)
        );

        return result;
    }
    
    /**
     * This method stores a custom validator under the given name.
     *
     * You can build the object by yourself and store it in your object:
     *
     * ```
     * myvalidator = new \UIM\Validation\Validator();
     * myvalidator
     *    .add("email", "valid-email", ["rule": "email"])
     *    .add("password", "valid", ["rule": "notBlank"])
     *    .allowEmpty("bio");
     * this.setValidator("forSubscription", myvalidator);
     * ```
     * Params:
     * string myname The name of a validator to be set.
     * @param \UIM\Validation\Validator myvalidator Validator object to be set.
     * /
    void setValidator(string myname, Validator myvalidator) {
        myvalidator.setProvider(VALIDATOR_PROVIDER_NAME, this);
       _validators[myname] = myvalidator;
    }
    
    /**
     * Checks whether a validator has been set.
     * Params:
     * string myname The name of a validator.
     * /
   bool hasValidator(string myname) {
        mymethod = "validation" ~ ucfirst(myname);
        if (this.validationMethodExists(mymethod)) {
            return true;
        }
        return isSet(_validators[myname]);
    }
    
    /**
     * Checks if validation method exists.
     * Params:
     * string myname Validation method name.
     * /
    protected bool validationMethodExists(string myname) {
        return method_exists(this, myname);
    }
    
    /**
     * Returns the default validator object. Subclasses can override this function
     * to add a default validation set to the validator object.
     * Params:
     * \UIM\Validation\Validator myvalidator The validator that can be modified to
     * add some rules to it.
     * /
    Validator validationDefault(Validator myvalidator) {
        return myvalidator;
    }
} */
