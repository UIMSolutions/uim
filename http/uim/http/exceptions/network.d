module uim.http.exceptions.network;

import uim.http;

@safe:

/**
 * Thrown when the request cannot be completed because of network issues.
 *
 * There is no response object as this exception is thrown when no response has been received.
 *
 * Example: the target host name can not be resolved or the connection failed.
 */
class DNetworkException { // }: RuntimeException : INetworkException {
    protected IRequest _request;

    this(string execeptionMessage, IRequest request, Throwable previousException = null) {
        _request = request;
        super(execeptionMessage, 0, previousException);
    }
    
    /**
     * Returns the request.
     * The request object MAY be a different object from the one passed to IClient.sendRequest()
     */
    IRequest getRequest() {
        return _request;
    }
}
