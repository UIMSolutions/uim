/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.errors.classes.middlewares.errorhandler;

@safe:
import uim.errors;

/**
 * Error handling middleware.
 *
 * Traps exceptions and converts them into HTML or content-type appropriate
 * error pages using the UIM ExceptionRenderer.
 */
class DErrorHandlerMiddleware : IErrorMiddleware {
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
    configuration.updateDefaults([
        "skipLog": Json.emptyArray,
        "log": true.toJson,
        "trace": false.toJson,
        "exceptionRenderer": ExceptionRenderer.classname,
    ]);

        return true;
    }

    mixin(TProperty!("string", "name"));

    /**
     * Error handler instance.
     * var DERRErrorHandler|null
     */
    protected myErrorHandler;

    this(ErrorHandler myErrorHandler = null) {
        if (func_num_args() > 1) {
            deprecationWarning(
                "The signature of ErrorHandlerMiddleware.this() has changed~ "
                ~ "Pass the config array as 1st argument instead."
           );

            myErrorHandler = func_get_arg(1);
        }

        if (D_VERSION_ID >= 70400 && Configure.read("debug")) {
            ini_set("zend.exception_ignore_args", "0");
        }

        if (myErrorHandler.isArray) {
            configuration.update(myErrorHandler);
            return;
        }

        if (!cast(ErrorHandler)myErrorHandler) {
            throw new DInvalidArgumentException(
                "myErrorHandler argument must be a config array or ErrorHandler instance. Got `%s` instead."
                .format(getTypeName(myErrorHandler)
           ));
        }

        this.errorHandler = myErrorHandler;
    }

    // Wrap the remaining middleware with error handling.
    IResponse process(IServerRequest request, IRequestHandler requestHandler) {
        try {
            return requestHandler.handle(request);
        } catch (DRedirectException exception) {
            return _handleRedirect(exception);
        } catch (Throwable exception) {
            return _handleException(exception, request);
        }
    }

    // Handle an exception and generate an error response
    IResponse handleException(Throwable exception, IServerRequest request) {
        myErrorHandler = getErrorHandler();
        renderer = myErrorHandler.getRenderer(exception, request);

        try {
            myErrorHandler.logException(exception, request);
            response = renderer.render();
        } catch (Throwable internalException) {
            myErrorHandler.logException@(DInternalException, request);
            response = handleInternalError();
        }

        return response;
    }

    // Convert a redirect exception into a response.
    IResponse handleRedirect(DRedirectException exceptionToHandle) {
        return new DRedirectResponse(
            exceptionToHandle.getMessage(),
            exceptionToHandle.code(),
            exceptionToHandle.getHeaders()
       );
    }

    // Handle internal errors.
    protected IResponse handleInternalError() {
        response = new DResponse(["body": "An Internal Server Error Occurred"]);

        return response.withStatus(500);
    }

    // Get a error handler instance
    protected ErrorHandler getErrorHandler() {
        if (this.errorHandler.isNull) {
            /** @var class-string<uim.errorss.ErrorHandler> myclassname */
            myclassname = App.classname("ErrorHandler", "Error");
            this.errorHandler = new myclassname(this.configuration.data);
        }

        return _errorHandler;
    } 
}
