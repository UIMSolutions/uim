module uim.errors.errors.handlers.errorhandler;

/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.errors.errors.errorhandler;

@safe:
import uim.errors;

/**
 * Error Handler provides basic error and exception handling for your application. It captures and
 * handles all unhandled exceptions and errors. Displays helpful framework errors when debug mode is on.
 *
 * ### Uncaught exceptions
 *
 * When debug mode is off a ExceptionRenderer will render 404 or 500 errors. If an uncaught exception is thrown
 * and it is a type that ExceptionRenderer does not know about it will be treated as a 500 error.
 *
 * ### Implementing application specific exception handling
 *
 * You can implement application specific exception handling in one of a few ways. Each approach
 * gives you different amounts of control over the exception handling process.
 *
 * - Modify config/error.D and setup custom exception handling.
 * - Use the `exceptionRenderer` option to inject an Exception renderer. This will
 *  let you keep the existing handling logic but override the rendering logic.
 *
 * #### Create your own Exception handler
 *
 * This gives you full control over the exception handling process. The class you choose should be
 * loaded in your config/error.D and registered as the default exception handler.
 *
 * #### Using a custom renderer with `exceptionRenderer`
 *
 * If you don"t want to take control of the exception handling, but want to change how exceptions are
 * rendered you can use `exceptionRenderer` option to choose a class to render exception pages. By default
 * `uim\errors.ExceptionRenderer` is used. Your custom exception renderer class should be placed in src/Error.
 *
 * Your custom renderer should expect an exception in its constructor, and implement a render method.
 * Failing to do so will cause additional errors.
 *
 * #### Logging exceptions
 *
 * Using the built-in exception handling, you can log all the exceptions
 * that are dealt with by ErrorHandler by setting `log` option to true in your config/error.D.
 * Enabling this will log every exception to Log and the configured loggers.
 *
 * ### D errors
 *
 * Error handler also provides the built in features for handling D errors (trigger_error).
 * While in debug mode, errors will be output to the screen using debugger. While in production mode,
 * errors will be logged to Log. You can control which errors are logged by setting
 * `errorLevel` option in config/error.D.
 *
 * #### Logging errors
 *
 * When ErrorHandler is used for handling errors, you can enable error logging by setting the `log`
 * option to true. This will log all errors to the configured log handlers.
 *
 * #### Controlling what errors are logged/displayed
 *
 * You can control which errors are logged / displayed by ErrorHandler by setting `errorLevel`. Setting this
 * to one or a combination of a few of the E_* constants will only enable the specified errors:
 *
 * ```
 * options["errorLevel"] = E_ALL & ~E_NOTICE;
 * ```
 *
 * Would enable handling for all non Notice errors.
 */
class DErrorHandler { // }: DERRErrorHandler
    this(Json initData = null) {
        initData += [
            "exceptionRenderer": ExceptionRenderer.class,
        ];

        configuration.update(aConfig);
    }

    /**
     * Display an error.
     * Template method of DERRErrorHandler.
     */
    protected void _displayError(Json[string] errorData, bool shouldDebug) {
        if (!shouldDebug) {
            return;
        }

        Debugger.getInstance().outputError(errorData);
    }

    // Displays an exception response body.
    protected void _displayException(Throwable exception) {
        try {
            renderer = getRenderer(
                exception,
                Router.getRequest()
           );
            response = renderer.render();
            _sendResponse(response);
        } catch (Throwable exception) {
            _logInternalError(exception);
        }
    }

    // Get a renderer instance.
    IExceptionRenderer getRenderer(
        Throwable exception,
        IServerRequest request = null
   ) {
        renderer = _config["exceptionRenderer"];

        if (renderer.isString) {
            /** @var class-string<uim.errors.IExceptionRenderer>|null aClassName */
            aClassName = App.className(renderer, "Error");
            if (!aClassName) {
                throw new DRuntimeException(format(
                        "The '%s' renderer class DCould not be found.",
                        renderer
               ));
            }

            return new aClassName(exception, request);
        }

        /** @var callable factory */
        factory = renderer;

        return factory(exception, request);
    }

    // Log internal errors.
    protected void _logInternalError(Throwable exception) {
        // Disable trace for internal errors.
        _config["trace"] = false;
        message = "[%s] %s (%s:%s)\n%s".format( // Keeping same message format
            get_class(exception),
            exception.getMessage(),
            exception.getFile(),
            exception.getLine(),
            exception.getTraceAsString()
       );
        trigger_error(message, ERRORS.USER_ERROR);
    }

    // Method that can be easily stubbed in testing.
    protected void _sendResponse(IResponse response) {
        auto emitter = new DResponseEmitter();
        emitter.emit(response);
    }

    protected void _sendResponse(string responseMessage) {
        writeln(response);
    }
}
