module uim.uim.http;

import uim.http;

@safe:

/**
 * Executes the middleware queue and provides the `next` callable
 * that allows the queue to be iterated.
 */
class DRunner : IRequestHandler {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    // The middleware queue being run.
    //protected IHttpMiddlewareQueue queue;

    // Fallback handler to use if middleware queue does not generate response.
    protected IRequestHandler fallbackHandler = null;

    /**
     * @param \UIM\Http\MiddlewareQueue queue The middleware queue
     * @param \Psr\Http\Message\IServerRequest serverRequest The Server Request
     * @param \Psr\Http\Server\IRequestHandler|null fallbackHandler Fallback request handler.
     * returns A response object
     * /
    IResponse run(
        MiddlewareQueue queue,
        IServerRequest serverRequest,
        ?IRequestHandler fallbackHandler = null
    ) {
        this.queue = queue;
        this.queue.rewind();
        this.fallbackHandler = fallbackHandler;

        if (
            cast(IRoutingApplication)fallbackHandler  &&
            cast(DServerRequest)request
        ) {
            Router.setRequest(request);
        }
        return _handle(request);
    }
    
    /**
     * Handle incoming server request and return a response.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest The server request
     * /
    IResponse handle(IServerRequest serverRequest) {
        if (this.queue.valid()) {
            middleware = this.queue.current();
            this.queue.next();

            return middleware.process(request, this);
        }
        if (this.fallbackHandler) {
            return _fallbackHandler.handle(request);
        }
        return new DResponse([
            'body": 'Middleware queue was exhausted without returning a response '
                ~ "and no fallback request handler was set for Runner",
            `status": 500,
        ]);
    } */
}
