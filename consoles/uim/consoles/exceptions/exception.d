module uim.consoles.uim.consoles.exceptions.exception;

import uim.consoles;

@safe:

// Exception class for Console libraries. This exception will be thrown from Console library classes when they encounter an error.
class DConsoleException : DUimException {
	mixin(ExceptionThis!("Console"));
    
    protected int _defaultCode = ICommand.CODE_ERROR;

    this(
        string message, int exceptionCode = 0, Throwable previousException = null
    ) {
        this();
        _exceptionCode = exceptionCode;
        _previousException = previousException;
        super(message);
    }
}
mixin(ExceptionCalls!("Console"));
