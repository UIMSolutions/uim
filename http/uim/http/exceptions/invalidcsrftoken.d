module uim.http.exceptions.invalidcsrftoken;

import uim.http;

@safe:

/**
 * Represents an HTTP 403 error caused by an invalid CSRF token
 */
class InvalidCsrfTokenException : DHttpException {
 
    protected int _defaultCode = 403;

    this(string exceptionMessage = null, int statusCode = null, Throwable previousException = null) {
        if (exceptionMessage.isEmpty) {
            exceptionMessage = "Invalid CSRF Token";
        }
        super(exceptionMessage, statusCode, previousException);
    }
}
