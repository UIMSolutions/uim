module uim.oop.exceptions.uim;

import uim.oop;

@safe:

// Base class that all UIM Exceptions extend.
class UimException : Exception {
    /**
     * Array of attributes that are passed in from the constructor, and
     * made available in the view when a development error is displayed.
     */
    protected IData[string] _attributes;

    // Template string that has attributes sprintf()'ed into it.
    protected string _messageTemplate = "";

    // Default exception code
    protected int _defaultCode = 0;

    /**
     * Constructor.
     *
     * Allows you to create exceptions that are treated as framework errors and disabled
     * when debug mode is off.
     * Params:
     * @param int statusCode The error code
     * @param \Throwable|null previous the previous exception.
     */
    this(IData[string] messageAttributes, int statusCode = 0, UimException previousException = null) {
        _attributes = messageAttributes;
        string errorMessage = _messageTemplate.format(message);
        this(errorMessage, statusCode, previousException);
    }

    this(string errorMessage = "", int statusCode = 0, UimException previousException = null) {
        // TODO super(errorMessage, statusCode ? statusCode : _defaultCode, previousException);
        super(errorMessage);
    }

    // Get the passed in attributes
    IData[string] attributes() {
        return _attributes;
    }
}
