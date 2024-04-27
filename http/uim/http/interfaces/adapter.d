module uim.http.interfaces.adapter;

import uim.http;

@safe:

// Http client adapter interface.
interface IAdapter {
    /**
     * Send a request and get a response back.
     * Params:
     * \Psr\Http\Message\IRequest request The request object to send.
     * @param Json[string] options Array of options for the stream.
     */
    IResponse[] send(IRequest aRequest, Json[string] options = null);
}
