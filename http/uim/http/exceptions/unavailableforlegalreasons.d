module uim.http.exceptions.unavailableforlegalreasons;

import uim.http;

@safe:

/**
 * Represents an HTTP 451 error.
 */
class UnavailableForLegalReasonsException : DHttpException {
 
    protected int _defaultCode = 451;

    /**
     * Constructor
     * Params:
     * string|null aMessage If no message is given 'Unavailable For Legal Reasons' will be the message
     */
    this(string amessage = null, int statusCode = 451, Throwable previousException = null) {
        if (aMessage.isEmpty) {
            aMessage = "Unavailable For Legal Reasons";
        }
        super(aMessage, statusCode, previousException);
    } */
 } 
