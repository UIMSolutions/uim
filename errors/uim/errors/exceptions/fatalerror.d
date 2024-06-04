module uim.errors.exceptions.fatalerror;

import uim.errors;

// Represents a fatal error
class DFatalErrorException : DException {
    mixin(ExceptionThis!("FatalError"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        this
            .messageTemplate("FatalError");

        return true;
    }

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
}
mixin(ExceptionCalls!("FatalError"));