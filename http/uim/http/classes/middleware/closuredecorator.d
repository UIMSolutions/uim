module uim.http.classes.middleware.closuredecorator;

import uim.http;

@safe:
/**
 * Decorate closures as PSR-15 middleware.
 *
 * Decorates closures with the following signature:
 *
 * ```
 * IResponse (
 *    IServerRequest serverRequest,
 *    IRequestHandler handler
 * ): 
 * ```
 *
 * such that it will operate as PSR-15 middleware.
 */
class DClosureDecoratorMiddleware { // }: IMiddleware {
    /**
     * A Closure.
     * /
    protected Closure aCallable;

    /**
     * Constructor
     * Params:
     * \Closure callable A closure.
     * /
    this(Closure aCallable) {
        this.callable = aCallable;
    }
    
    /**
     * Run the callable to process an incoming server request.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest Request instance.
     * @param \Psr\Http\Server\IRequestHandler handler Request handler instance.
     * /
    IResponse process(IServerRequest serverRequest, IRequestHandler handler) {
        return (this.callable)(
            request,
            handler
        );
    }
    
    Closure getCallable() {
        return this.callable;
    } */
}
