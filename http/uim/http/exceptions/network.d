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
    /**
     * @var \Psr\Http\Message\IRequest
     * /
    protected IRequest request;

    /**
     * Constructor.
     * Params:
     * string amessage Exeception message.
     * @param \Psr\Http\Message\IRequest request Request instance.
     * @param \Throwable|null previous Previous Exception
     * /
    this(string amessage, IRequest request, Throwable previousException = null) {
        this.request = request;
        super(message, 0, previous);
    }
    
    /**
     * Returns the request.
     *
     * The request object MAY be a different object from the one passed to IClient.sendRequest()
     * /
    IRequest getRequest() {
        return _request;
    } */
}
