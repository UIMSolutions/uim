/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module errors.uim.errors.classes.middlewares.errorhandler;

@safe:
import uim.errors;

/**
 * Error handling middleware.
 *
 * Traps exceptions and converts them into HTML or content-type appropriate
 * error pages using the UIM ExceptionRenderer.
 */
class DErrorHandlerMiddleware : IMiddleware {
        mixin TConfigurable!();

    this() {
        initialize;
    }

    this(IData[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    /**
     * Default configuration values.
     *
     * Ignored if contructor is passed an ErrorHandler instance.
     *
     * - `log` Enable logging of exceptions.
     * - `skipLog` List of exceptions to skip logging. Exceptions that
     *   extend one of the listed exceptions will also not be logged. Example:
     *
     *   ```
     *   "skipLog":["Cake\errors.NotFoundException", "Cake\errors.UnauthorizedException"]
     *   ```
     *
     * - `trace` Should error logs include stack traces?
     * - `exceptionRenderer` The renderer instance or class name to use or a callable factory
     *   which returns a uim.errorss.IExceptionRenderer instance.
     *   Defaults to uim.errorss.ExceptionRenderer
     *
     * @var array<string, mixed>
     * /
    configuration.updateDefaults([
        "skipLog":[],
        "log":true,
        "trace":false,
        "exceptionRenderer":ExceptionRenderer::class,
    ]);

    /**
     * Error handler instance.
     *
     * var DERRErrorHandler|null
     * /
    protected myErrorHandler;

    /**
     * Constructor
     *
     * @param uim.errorss.ErrorHandler|array myErrorHandler The error handler instance
     *  or config array.
     * @throws \InvalidArgumentException
     * /
    this(myErrorHandler = null) {
        if (func_num_args() > 1) {
            deprecationWarning(
                "The signature of ErrorHandlerMiddleware::this() has changed~ "
                ~ "Pass the config array as 1st argument instead."
            );

            myErrorHandler = func_get_arg(1);
        }

        if (PHP_VERSION_ID >= 70400 && Configure::read("debug")) {
            ini_set("zend.exception_ignore_args", "0");
        }

        if ((myErrorHandler.isArray) {
            configuration.update(myErrorHandler);

            return;
        }

        if (!myErrorHandler instanceof ErrorHandler) {
            throw new DInvalidArgumentException(sprintf(
                "myErrorHandler argument must be a config array or ErrorHandler instance. Got `%s` instead.",
                getTypeName(myErrorHandler)
            ));
        }

        this.errorHandler = myErrorHandler;
    }

    /**
     * Wrap the remaining middleware with error handling.
     *
     * @param \Psr\Http\messages.IServerRequest myRequest The request.
     * @param \Psr\Http\servers.IRequestHandler handler The request handler.
     * @return \Psr\Http\messages.IResponse A response.
     * /
    IResponse process(IServerRequest myRequest, IRequestHandler handler) {
        try {
            return handler.handle(myRequest);
        } catch (RedirectException myException) {
            return this.handleRedirect(myException);
        } catch (Throwable myException) {
            return this.handleException(myException, myRequest);
        }
    }

    /**
     * Handle an exception and generate an error response
     *
     * @param \Throwable myException The exception to handle.
     * @param \Psr\Http\messages.IServerRequest myRequest The request.
     * @return \Psr\Http\messages.IResponse A response
     * /
    IResponse handleException(Throwable myException, IServerRequest myRequest) {
        myErrorHandler = this.getErrorHandler();
        renderer = myErrorHandler.getRenderer(myException, myRequest);

        try {
            myErrorHandler.logException(myException, myRequest);
            response = renderer.render();
        } catch (Throwable internalException) {
            myErrorHandler.logException(internalException, myRequest);
            response = this.handleInternalError();
        }

        return response;
    }

    /**
     * Convert a redirect exception into a response.
     *
     * @param uim.cake.http.exceptions.RedirectException myException The exception to handle
     * @return \Psr\Http\messages.IResponse Response created from the redirect.
     * /
    IResponse handleRedirect(RedirectException myException) {
        return new DRedirectResponse(
            myException.getMessage(),
            myException.getCode(),
            myException.getHeaders()
        );
    }

    /**
     * Handle internal errors.
     *
     * @return \Psr\Http\messages.IResponse A response
     * /
    protected IResponse handleInternalError() {
        response = new DResponse(["body":"An Internal Server Error Occurred"]);

        return response.withStatus(500);
    }

    /**
     * Get a error handler instance
     *
     * @return uim.errorss.ErrorHandler The error handler.
     * /
    protected auto getErrorHandler(): ErrorHandler
    {
        if (this.errorHandler is null) {
            /** @var class-string<uim.errorss.ErrorHandler> myClassName * /
            myClassName = App::className("ErrorHandler", "Error");
            this.errorHandler = new myClassName(this.configuration.data);
        }

        return this.errorHandler;
    } */
}
