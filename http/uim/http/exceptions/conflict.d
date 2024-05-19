module uim.http.exceptions.conflict;

import uim.http;

@safe:

// Represents an HTTP 409 error.
class DConflictException : DHttpException {
 
    protected int _defaultCode = 409;

    /* 
    this(string exceptionMessage = null, int statusCode = null, Throwable previousException = null) {
        if (exceptionMessage.isEmpty) {
            exceptionMessage = "Conflict";
        }
        super(exceptionMessage, statusCode, previousException);
    }
}
