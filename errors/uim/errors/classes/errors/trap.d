module uim.errors.classes.errors.trap;

import uim.errors;

@safe:

/**
 * Entry point to UIM`s error handling.
 *
 * Using the `register()` method you can attach an ErrorTrap to D`s default error handler.
 *
 * When errors are trapped, errors are logged (if logging is enabled). Then the `Error.beforeRender` event is triggered.
 * Finally, errors are 'rendered' using the defined renderer. If no error renderer is defined in configuration
 * one of the default implementations will be chosen based on the UIM SAPI.
 */
class DErrorTrap {
    mixin TConfigurable;
    // @use \UIM\Event\EventDispatcherTrait<\UIM\Error\ErrorTrap>
    // TODO mixin TEventDispatcher;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        /**
        * Configuration options. Generally these are defined in config/app.d
        *
        * - `errorLevel` - int - The level of errors you are interested in capturing.
        * - `errorRenderer` - string - The class name of render errors with. Defaults
        * to choosing between Html and Console based on the SAPI.
        * - `log` - boolean - Whether or not you want errors logged.
        * - `logger` - string - The class name of the error logger to use.
        * - `trace` - boolean - Whether or not backtraces should be included in logged errors.
        */
        configuration.updateDefaults([
            // TODOD "errorLevel": E_ALL,
            "errorRenderer": Json(null),
            "log": true.toJson,
            // TODO "logger": ErrorLogger.classname,
            "trace": false.toJson,
        ]);

        return true;
    }

    mixin(TProperty!("string", "name"));

    /*
    // Choose an error renderer based on config or the SAPI
    protected string chooseErrorRenderer() {
        configData = _configData.hasKey("errorRenderer");
        if (configData !is null) {
            return configData;
        }
        /** @var class-string<\UIM\Error\IErrorRenderer> */
    return UIM_SAPI == "cli" ? ConsoleErrorRenderer.classname : HtmlErrorRenderer.classname;
}

/**
     * Attach this ErrorTrap to D`s default error handler.
     *
     * This will replace the existing error handler, and the
     * previous error handler will be discarded.
     *
     * This method will also set the global error level
     * via error_reporting().
     */
    void register() {
        auto level = configuration.getLong("errorLevel", -1);
        error_reporting(level);
        set_error_handler(this.handleError(...), level);
    }
    
    /**
     * Handle an error from UIM set_error_handler
     *
     * Will use the configured renderer to generate output
     * and output it.
     *
     * This method will dispatch the `Error.beforeRender` event which can be listened
     * to on the global event manager.
     */
    bool handleError(
        int errorCode,
        string errorDescription,
        string fileName = null,
        int errorTriggerLine = null
   ) {
        if (!(error_reporting() & errorCode)) {
            return false;
        }
        if (errorCode == ERRORS.USER_ERROR ||  errorCode == ERRORS.ERROR || errorCode == ERRORS.PARSE) {
            throw new DFatalErrorException(errorDescription, errorCode, fileName, errorTriggerLine);
        }
        auto trace = /* (array) */Debugger.trace(["start": 1, "format": "points"]);
        auto error = new UIMError(errorCode, errorDescription, fileName, errorTriggerLine, trace);

        auto anIgnoredPaths = /* (array) */configuration.get("Error.ignoredDeprecationPaths");
        if (errorCode == ERRORS.USER_DEPRECATED &&  anIgnoredPaths) {
            string relativePath = subString(fileName, ROOT.length + 1).replace(DIRECTORY_SEPARATOR, "/");
            foreach (somePattern; anIgnoredPaths) {
                string somePattern = somePattern.replace(DIRECTORY_SEPARATOR, "/");
                if (fnmatch(somePattern, relativePath)) {
                    return true;
                }
            }
        }
        debug = configuration.get("debug");
        renderer = this.renderer();

        try {
            // Log first incase rendering or event listeners fail
            logError(error);
            event = dispatchEvent("Error.beforeRender", ["error": error]);
            if (event.isStopped()) {
                return true;
            }
            renderer.write(event.getResult() ?: renderer.render(error, debug));
        } catch (Exception exception) {
            // Fatal errors always log.
            logger().logException(exception);
            return false;
        }
        return true;
    }
    
    /**
     * Logging helper method.
     * Params:
     * \UIM\Error\UIMError error The error object to log.
     */
    protected void logError(UIMError error) {
        if (!configuration.hasKey("log")) {
            return;
        }
        logger().logError(error, Router.getRequest(), configuration.get("trace"));
    }
    
    // Get an instance of the renderer.
    IErrorRenderer renderer() {
        string classname = _configData.getString("errorRenderer", chooseErrorRenderer());

        return new classname(_config);
    }
    
    // Get an instance of the logger.
    IErrorLogger logger() {
        string classname = configData.getString("logger", defaultconfiguration.getString("logger"));
        return new classname(_config);
    } 
}
