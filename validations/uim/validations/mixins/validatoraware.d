/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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
 * in validators.
 * - `BUILD_VALIDATOR_EVENT` - The name of the event to be triggred when validators
 * are built.
 *
 * If the including class DAlso : events the `Model.buildValidator` event
 * will be triggered when validators are created.
 */
mixin template TValidatorAware() {
    // A list of validation objects indexed by name
    protected DValidator[] _validators;

    // Validator class.
    protected string _validatorClass; // = Validator.classname;

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
     *   return myvalidator
     *       .add("email", "valid-email", ["rule", "email"])
     *       .add("password", "valid", ["rule", "notBlank"])
     *       .requirePresence("username");
     * }
     *
     * myvalidator = getValidator("forSubscription");
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
     * string myname The name of the validation set to return.
     */
    IValidator getValidator(string myname = null) {
        /* myname = myname ?: DEFAULT_VALIDATOR;
        if (!_validators.hasKey(myname)) {
            setValidator(myname, this.createValidator(myname));
        }
        return _validators[myname]; */
        return null;
    }

    /**
     * Creates a validator using a custom method inside your class.
     *
     * This method is used only to build a new validator and it does not store
     * it in your object. If you want to build and reuse validators,
     * use getValidator() method instead.
     * Params:
     * string myname The name of the validation set to create.
     */
    protected IValidator createValidator(string validationSetName) {
        auto mymethod = "validation" ~ capitalize(validationSetName);
        if (!this.validationMethodExists(mymethod)) {
            auto mymessage = "The `%s.%s()` validation method does not exists.".format("class", mymethod);
            /* throw new DInvalidArgumentException(mymessage); */
        }

        /* DValidator result = mymethod(new _validatorClass());
        if (cast(IEventDispatcher)this) {
            /* auto validatorEvent = defined("class" ~ ".BUILD_VALIDATOR_EVENT")
                ? BUILD_VALIDATOR_EVENT
                : "Model.buildValidator";
            dispatchEvent(validatorEvent/* , compact("validator", "name") * /);  * /
        }
        assert(
            cast(DValidator)result,
                "The `%s.%s()` validation method must return an instance of `%s`."
                .format("class", mymethod, result.classname)
       ); */

        // return result;
        return null;
    }

    /**
     * This method stores a custom validator under the given name.
     *
     * You can build the object by yourself and store it in your object:
     *
     * ```
     * myvalidator = new \UIM\Validation\Validator();
     * myvalidator
     *   .add("email", "valid-email", ["rule", "email"])
     *   .add("password", "valid", ["rule", "notBlank"])
     *   .allowEmpty("bio");
     * setValidator("forSubscription", myvalidator);
     * ```
     * Params:
     * string myname The name of a validator to be set.
     */
    void setValidator(string name, DValidator validator) {
        /* validator.setProvider(VALIDATOR_PROVIDER_NAME, this);
       _validators[name] = validator; */
    }

    // Checks whether a validator has been set.
    bool hasValidator(string validatorName) {
        auto mymethod = "validation" ~ capitalize(validatorName);
        if (validationMethodExists(mymethod)) {
            return true;
        }
        // return _validators.hasKey(validatorName);
        return false;
    }

    // Checks if validation method exists.
    protected bool validationMethodExists(string methodName) {
        // return hasMethod(this, methodName);
        return false;
    }

    /**
     * Returns the default validator object. Subclasses can override this function
     * to add a default validation set to the validator object.
     * Params:
     * \UIM\Validation\Validator myvalidator The validator that can be modified to
     * add some rules to it.
     */
    DValidator validationDefault(DValidator myvalidator) {
        return myvalidator;
    }
}
