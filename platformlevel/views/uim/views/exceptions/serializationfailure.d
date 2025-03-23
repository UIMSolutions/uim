/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.exceptions.serializationfailure;

import uim.views;
@safe:

// Used when a SerializedView class fails to serialize data.
class DSerializationFailureException : DViewException {
    mixin(ExceptionThis!("SerializationFailure"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }
}
mixin(ExceptionCalls!("SerializationFailure"));

