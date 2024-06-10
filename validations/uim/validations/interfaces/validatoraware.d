module uim.validations.interfaces.validatoraware;

import uim.validations;

@safe:

// Provides methods for managing multiple validators.
interface IValidatorAware {
    /**
     * Returns the validation rules tagged with myname.
     *
     * If a myname argument has not been provided, the default validator will be returned.
     * You can configure your default validator name in a `DEFAULT_VALIDATOR`
     * class DConstant.
     * Params:
     * string myname The name of the validation set to return.
     */
    Validator getValidator(string myname = null);

    /**
     * This method stores a custom validator under the given name.
     * Params:
     * @param \UIM\Validation\Validator myvalidator Validator object to be set.
     */
    void setValidator(string validatorName, Validator myvalidator);

    // Checks whether a validator has been set.
   bool hasValidator(string validatorName);
}
