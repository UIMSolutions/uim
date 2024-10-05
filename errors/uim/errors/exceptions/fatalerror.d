/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.exceptions.fatalerror;

import uim.errors;

// Represents a fatal error
class DFatalErrorException : UIMException {
    mixin(ExceptionThis!("FatalError"));

    this(
        string message,
        int code = 0,
        string fileName = null,
        int lineNumber = 0,
        Throwable previousException = null
    ) {
        super(message, code, previousException);
        if (fileName) {
            _fileName = fileName;
        }
        if (lineNumber > 0) { // TODO Logical error 
            _lineNumber = lineNumber;
        }
    }

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        messageTemplate("default", "FatalError");

        return true;
    }
}

mixin(ExceptionCalls!("FatalError"));

unittest {
    testException(FatalErrorException);
}
