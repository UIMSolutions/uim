/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.middlewares.errorhandler;

import uim.errors;

@safe:

/**
 * Error handling middleware.
 *
 * Traps exceptions and converts them into HTML or content-type appropriate
 * error pages using the UIM ExceptionRenderer.
 */
class DErrorHandlerMiddleware : UIMObject, IErrorMiddleware {
    this(Json[string] initData = null) {
        super(initData);
    }

    this(IErrorHandler newErrorHandler = null, Json[string] initData = null) {
        super(initData);
        _errorHandler = newErrorHandler;
    }

    // Hook method
    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        /**
        * Default configuration values.
        *
        * Ignored if contructor is passed an ErrorHandler instance.
        *
        * - `log` Enable logging of exceptions.
        * - `skipLog` List of exceptions to skip logging. Exceptions that
        *  extend one of the listed exceptions will also not be logged. Example:
        *
        *  ```
        *  "skipLog": ["uim\errors.NotFoundException", "uim\errors.UnauthorizedException"]
        *  ```
        *
        * - `trace` Should error logs include stack traces?
        * - `exceptionRenderer` The renderer instance or class name to use or a callable factory
        *  which returns a uim.errorss.IExceptionRenderer instance.
        *  Defaults to uim.errorss.ExceptionRenderer
        */
/*         configuration
            .setDefault("skipLog", Json.emptyArray)
            .setDefault("log", true)
            .setDefault("trace", false)
            .setDefault("exceptionRenderer", ExceptionRenderer.classname); */

        return true;
    }

    // Error handler instance.
    protected IErrorHandler _errorHandler;

    // Wrap the remaining middleware with error handling.
    /* IResponse process(IServerRequest request, IRequestHandler requestHandler) {
        try {
            return requestHandler.handle(request);
        }  /* catch (DRedirectException exception) {
            return _handleRedirect(exception);
        } * /
        catch (Throwable exception) {
            return _handleException(exception, request);
        }
    } */

    // Handle an exception and generate an error response
    /* IResponse handleException(Throwable exception, IServerRequest request) {
        auto _errorHandler = getErrorHandler();
        auto renderer = _errorHandler.getRenderer(exception, request);

        IResponse response;
        try {
            _errorHandler.logException(exception, request);
            response = renderer.render();
        } catch (Throwable internalException) {
            /*  _errorHandler.logException@(DInternalException, request);
            response = handleInternalError(); * /
        }

        return response;
    } */

    // Convert a redirect exception into a response.
    /*     IResponse handleRedirect(DRedirectException exceptionToHandle) {
        return new DRedirectResponse(
            exceptionToHandle.message(),
            exceptionToHandle.code(),
            exceptionToHandle.getHeaders()
        );
    }
 */
    // Handle internal errors.
    /* protected IResponse handleInternalError() {
        response = new DResponse(["body": "An Internal Server Error Occurred"]);

        return response.withStatus(500);
    } */

    // Get a error handler instance
    protected IErrorHandler getErrorHandler() {
        /* if (_errorHandler.isNull) {
            /** @var class-string<uim.errorss.ErrorHandler> myclassname * /
            myclassname = App.classname("ErrorHandler", "Error");
            // _errorHandler = new myclassname(this.configuration.data);
        }

        return _errorHandler; */
        return null; // TODO
    }
}
