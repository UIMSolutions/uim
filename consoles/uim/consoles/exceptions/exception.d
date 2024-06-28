module uim.consoles.exceptions.exception;

import uim.consoles;

@safe:

// Exception class for Console libraries. This exception will be thrown from Console library classes when they encounter an error.
class DConsoleException : DException {
	mixin(ExceptionThis!("Console"));
    
    protected int _defaultCode; // = DCommand.CODERRORS.ERROR;
    protected int _exceptionCode;
    protected Throwable _previousException;

    this(
        string message, int exceptionCode = 0, Throwable previousException = null
   ) {
        this();
        _exceptionCode = exceptionCode;
        _previousException = previousException;
        // TODO super(message);
    }
}
mixin(ExceptionCalls!("Console"));
