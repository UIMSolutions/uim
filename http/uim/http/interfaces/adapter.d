module uim.cake.http.interfaces.adapter;

import uim.cake;

@safe:

// Http client adapter interface.
interface IAdapter {
    /**
     * Send a request and get a response back.
     * Params:
     * \Psr\Http\Message\IRequest request The request object to send.
     * @param IData[string] options Array of options for the stream.
     */
    Response[] send(IRequest aRequest, IData[string] options = null);
}
