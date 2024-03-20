module uim.http\Exception;

import uim.http;

@safe:

/*
 * Parent class for all the HTTP related exceptions in UIM.
 * All HTTP status/error related exceptions should extend this class so
 * catch blocks can be specifically typed.
 *
 * You may also use this as a meaningful bridge to {@link \UIM\Core\Exception\UimException}, e.g.:
 * throw new \UIM\Network\Exception\HttpException("HTTP Version Not Supported", 505);
 */
class HttpException : UimException {
 
    protected int _defaultCode = 500;

    // Set a single HTTP response header.
    void header(string headerName, Json headerValue = null) {
        this.headers[headerName] = headerValue;
    }

    void header(string aheader, string[]|null aValue = null) {
        this.headers[aHeader] = aValue;
    }
    
    // Gets/Sets HTTP response headers.
    mixin(TProperty!("IData[string]", "headers"));
}
