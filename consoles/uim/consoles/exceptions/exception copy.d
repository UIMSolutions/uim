module uim.consoles.uim.consoles.exceptions.exception copy;

import uim.consoles;

@safe:

// Exception class for Console libraries. This exception will be thrown from Console library classes when they encounter an error.
class ConsoleException : DException {
	mixin(ExceptionThis!("ConsoleException"));
    
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
