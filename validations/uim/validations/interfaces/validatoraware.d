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
     */
    DValidator getValidator(string name = null);

    // This method stores a custom validator under the given name.
    void setValidator(string validatorName, DValidator validator);

    // Checks whether a validator has been set.
   bool hasValidator(string validatorName);
}
