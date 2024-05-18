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
class DClosureDecoratorMiddleware { // }: IHttpMiddleware {
    protected IClosure aCallable;

    /**
     
     * Params:
     * \Closure callable A closure.
     */
    this(IClosure aCallable) {
        _callable = aCallable;
    }
    
    /**
     * Run the callable to process an incoming server request.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest Request instance.
     * @param \Psr\Http\Server\IRequestHandler handler Request handler instance.
     */
    IResponse process(IServerRequest serverRequest, IRequestHandler handler) {
        return (_callable)(
            request,
            handler
        );
    }
    
    Closure getCallable() {
        return _callable;
    } */
}
