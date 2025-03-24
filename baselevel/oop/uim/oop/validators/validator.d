/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.validators.validator;

mixin(Version!"test_uim_oop");

import uim.oop;
@safe:

// Base class for validators
class DUIMValidator : UIMObject, IValidator {
/*    mixin TLocatorAware;
    mixin TLog; */

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }
}
