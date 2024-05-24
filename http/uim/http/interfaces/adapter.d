module uim.http.interfaces.adapter;

import uim.http;

@safe:

// Http client adapter interface.
interface IAdapter {
    // Send a request and get a response back.
    IResponse[] send(IRequest requestObjectToSend, Json[string] streamOptions = null);
}
