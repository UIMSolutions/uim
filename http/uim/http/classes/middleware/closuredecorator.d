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
 *   IServerRequest serverRequest,
 *   IRequestHandler handler
 *): 
 * ```
 *
 * such that it will operate as PSR-15 middleware.
 */
class DClosureDecoratorMiddleware : DMiddleware { // }: IHttpMiddleware {
    mixin(MiddlewareThis!("ClosureDecorator"));

    protected IClosure aCallable;

    this(IClosure aCallable) {
        _callable = aCallable;
    }
    
    // Run the callable to process an incoming server request.
    IResponse process(IServerRequest serverRequest, IRequestHandler requestHandler) {
        return (_callable)(
            serverRequest,
            requestHandler
       );
    }
    
    Closure getCallable() {
        return _callable;
    }
}
