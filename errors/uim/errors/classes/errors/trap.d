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
 * one of the default implementations will be chosen based on the D SAPI.
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
        configData = _configData.isSet("errorRenderer");
        if (configData !isNull) {
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
        auto level = configuration.getInteger("errorLevel", -1);
        error_reporting(level);
        set_error_handler(this.handleError(...), level);
    }
    
    /**
     * Handle an error from D set_error_handler
     *
     * Will use the configured renderer to generate output
     * and output it.
     *
     * This method will dispatch the `Error.beforeRender` event which can be listened
     * to on the global event manager.
     * Params:
     * int code Code of error
     * @param string adescription Error description
     * @param string file File on which error occurred
     * @param int line Line that triggered the error
     */
    bool handleError(
        int errorCode,
        string adescription,
        string afile = null,
        int line = null
    ) {
        if (!(error_reporting() & errorCode )) {
            return false;
        }
        if (errorCode == E_USER_ERROR ||  errorCode == E_ERROR || errorCode == E_PARSE) {
            throw new DFatalErrorException(description, errorCode, file, line);
        }
        auto trace = (array)Debugger.trace(["start": 1, "format": "points"]);
        auto error = new UimError(errorCode, description, file, line, trace);

        auto anIgnoredPaths = (array)configuration.get("Error.ignoredDeprecationPaths");
        if (errorCode == E_USER_DEPRECATED &&  anIgnoredPaths) {
            auto relativePath = substr((string)file, ROOT.length + 1).replace(DIRECTORY_SEPARATOR, "/");
            foreach (somePattern; anIgnoredPaths) {
                auto somePattern = somePattern..replace(DIRECTORY_SEPARATOR, "/");
                if (fnmatch(somePattern, relativePath)) {
                    return true;
                }
            }
        }
        debug = configuration.get("debug");
        renderer = this.renderer();

        try {
            // Log first incase rendering or event listeners fail
            this.logError(error);
            event = this.dispatchEvent("Error.beforeRender", ["error": error]);
            if (event.isStopped()) {
                return true;
            }
            renderer.write(event.getResult() ?: renderer.render(error, debug));
        } catch (Exception  anException) {
            // Fatal errors always log.
            this.logger().logException(anException);

            return false;
        }
        return true;
    }
    
    /**
     * Logging helper method.
     * Params:
     * \UIM\Error\UimError error The error object to log.
     */
    protected void logError(UimError error) {
        if (!configuration.get("log")) {
            return;
        }
        this.logger().logError(error, Router.getRequest(), configuration.get("trace"]);
    }
    
    /**
     * Get an instance of the renderer.
     */
    IErrorRenderer renderer() {
        string className = _configData.get("errorRenderer", this.chooseErrorRenderer());

        return new className(_config);
    }
    
    // Get an instance of the logger.
    IErrorLogger logger() {
        string className = configData.get("logger", defaultconfiguration.get("logger"));
        return new className(_config);
    } */
}
