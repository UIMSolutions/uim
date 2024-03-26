module uim.http.exceptions.internalerror;

import uim.http;

@safe:

// Represents an HTTP 500 error.
class InternalErrorException : DHttpException {
    protected int _defaultCode = 500;
    
    /* 
    this(string exceptionMessage = null, int statusCode = null, Throwable previousException = null) {
        if (exceptionMessage.isEmpty) {
            exceptionMessage = "Internal Server Error";
        }
        super(exceptionMessage, statusCode, previousException);
    } */
}
