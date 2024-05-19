module uim.http.exceptions.serviceunavailable;

import uim.http;

@safe:

// Represents an HTTP 503 error.
class DServiceUnavailableException : DHttpException {
 
    protected int _defaultCode = 503;
    /*
    this(string exceptionMessage = null, int statusCode = null, Throwable previousException = null) {
        if (exceptionMessage.isEmpty) {
            exceptionMessage = "Service Unavailable";
        }
        super(exceptionMessage, statusCode, previousException);
    }
}
