module oop.uim.oop.validators.validator;

import uim.oop;
@safe:

// Base class for validators
class DValidator : UIMObject, IValidator {
/*     mixin TLocatorAware;
    mixin TLog; */

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }
}
