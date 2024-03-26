module uim.http.exceptions.unauthorized;

import uim.http;

@safe:

/**
 * Represents an HTTP 401 error.
 */
class DUnauthorizedException : DHttpException {
 
    protected int _defaultCode = 401;

    /**
     * Constructor
     * Params:
     * string|null aMessage If no message is given 'Unauthorized' will be the message
     * /
    this(string aMessage = null, int statusCode = null, Throwable previousException = null) {
        if (aMessage.isEmpty) {
            aMessage = "Unauthorized";
        }
        super(aMessage, statusCode, previousException);
    } */
}
