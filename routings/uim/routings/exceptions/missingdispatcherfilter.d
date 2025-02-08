/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.routings.exceptions.missingdispatcherfilter;

import uim.routings;

@safe:

// Exception raised when a Dispatcher filter could not be found
class DMissingDispatcherFilterException : DException {
    mixin(ExceptionThis!("MissingDispatcherFilter"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        messageTemplate("default", "Dispatcher filter `%s` could not be found.");

        return true;
    }
}

mixin(ExceptionCalls!("MissingDispatcherFilter"));

unittest {
  assert(testException(MissingDispatcherFilterException));
}