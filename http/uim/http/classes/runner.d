/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.runner;

import uim.http;

@safe:

/**
 * Executes the middleware queue and provides the `next` callable
 * that allows the queue to be iterated.
 */
class DRunner : UIMObject, IRequestHandler {
    this() {
        super();
    }

    this(Json[string] initData) {
        super(initData);
    }

    this(string name) {
        super(name);
    }

    // The middleware queue being run.
    //protected IHttpMiddlewareQueue queue;

    // Fallback handler to use if middleware queue does not generate response.
    protected IRequestHandler fallbackHandler = null;

    IResponse run(
        DMiddlewareQueue middlewareQueue,
        IServerRequest serverRequest,
        IRequestHandler fallbackHandler = null
   ) {
        _queue = middlewareQueue;
        _queue.rewind();
        _fallbackHandler = fallbackHandler;

        if (
            cast(IRoutingApplication)fallbackHandler  &&
            cast(DServerRequest)serverRequest
       ) {
            Router.setRequest(serverRequest);
        }
        return _handle(serverRequest);
    }
    
    // Handle incoming server request and return a response.
    IResponse handle(IServerRequest serverRequest) {
        if (_queue.valid()) {
            middleware = _queue.currentValue();
            _queue.next();

            return middleware.process(request, this);
        }
        if (_fallbackHandler) {
            return _fallbackHandler.handle(request);
        }
        
        return new DResponse([
            "body": "Middleware queue was exhausted without returning a response "
                ~ "and no fallback request handler was set for Runner",
            "status": 500,
        ]);
    }
}
