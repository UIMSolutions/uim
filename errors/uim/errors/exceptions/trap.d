module uim.errors.exceptions.trap;

import uim.errors;

@safe:

/**
 * Entry point to UIM`s exception handling.
 *
 * Using the `register()` method you can attach an ExceptionTrap to D`s default exception handler and register
 * a shutdown handler to handle fatal errors.
 *
 * When exceptions are trapped the `Exception.beforeRender` event is triggered.
 * Then exceptions are logged (if enabled) and finally 'rendered' using the defined renderer.
 *
 * Stopping the `Exception.beforeRender` event has no effect, as we always need to render
 * a response to an exception and custom renderers should be used if you want to replace or
 * skip rendering an exception.
 *
 * If undefined, an ExceptionRenderer will be selected based on the current SAPI (CLI or Web).
 */
class DExceptionTrap {
    // TODO mixin TRequest;

    /**
     * Configuration options. Generally these will be defined in your config/app.d
     *
     * - `exceptionRenderer` - string - The class responsible for rendering uncaught exceptions.
     *  The chosen class will be used for for both CLI and web environments. If  you want different
     *  classes used in CLI and web environments you'll need to write that conditional logic as well.
     *  The conventional location for custom renderers is in `src/Error`. Your exception renderer needs to
     *  implement the `render()` method and return either a string or Http\Response.
     * - `log` Set to false to disable logging.
     * - `logger` - string - The class name of the error logger to use.
     * - `trace` - boolean - Whether or not backtraces should be included in
     *  logged exceptions.
     * - `skipLog` - array - List of exceptions to skip for logging. Exceptions that
     *  extend one of the listed exceptions will also not be logged. E.g.:
     *  ```
     *  `skipLog": ["UIM\Http\Exception\NotFoundException", "UIM\Http\Exception\UnauthorizedException"]
     *  ```
     *  This option is forwarded to the configured `logger`
     * - `extraFatalErrorMemory` - int - The number of megabytes to increase the memory limit by when a fatal error is
     *  encountered. This allows breathing room to complete logging or error handling.
     * - `stderr` Used in console environments so that renderers have access to the current console output stream.
     *
     */

    protected Json[string] _configData;


    /**
     * A list of handling callbacks.
     *
     * Callbacks are invoked for each error that is handled.
     * Callbacks are invoked in the order they are attached.
     * /
    protected IClosure[] aCallbacks;

    /**
     * The currently registered global exception handler
     *
     * This is best effort as we can`t know if/when another
     * exception handler is registered.
     * /
    protected static DExceptionTrap RegisteredTrap;

    // Track if this trap was removed from the global handler.
    protected bool isDisabled;

     this() {
      initialize;
     }
    this(Json[string] options = null) {
        this();
        _configData = merge(options, _configData);
    }

  bool initialize(Json[string] initData = null) {
    configuration.updateDefaults([
      "exceptionRenderer": Json(null),
      "logger": StringData(ErrorLogger.classname),
      "stderr": Json(null),
      "log": Json(true),
      "skipLog": Json.emptyArray,
      "trace": Json(false),
      "extraFatalErrorMemory": IntegerData(4)
    ];

    _configData = merge(initData, defaultData);
    return true;
  }
    
    /**
     * Get an instance of the renderer.
     * Params:
     * \Throwable renderException Exception to render
     * @param \Psr\Http\Message\IServerRequest|null serverRequest The request if possible.
     *  /
    IExceptionRenderer renderer(Throwable renderException, IServerRequest serverRequest = null) {
        auto myRequest = serverRequest.isNull ? Router.getRequest() : serverRequest;

        string className = _configData.isSet("exceptionRenderer") ? _configData("exceptionRenderer"] : this.chooseRenderer();
        if (isString(className)) {
            if (!isSubclass_of(className, IExceptionRenderer.className)) {
                throw new DInvalidArgumentException(
                    "Cannot use `{ className}` as an `exceptionRenderer`. " .
                    'It must be an instance of `UIM\Error\IExceptionRenderer`.'
                );
            }
            /** @var class-string<\UIM\Error\IExceptionRenderer>  className * /
            return new className(renderException, myRequest, _configData);
        }
        return className(renderException, myRequest);
    }
    
    // Choose an exception renderer based on config or the SAPI
    protected string chooseRenderer() {
        /** @var class-string<\UIM\Error\IExceptionRenderer> * /
        return UIM_SAPI == "cli" ? ConsoleExceptionRenderer.classname : WebExceptionRenderer.classname;
    }
    
    // Get an instance of the logger.
    IErrorLogger logger() {
        /** @var class-string<\UIM\Error\IErrorLogger>  className * /
         className = _configData.isSet("logger", _defaultConfigData["logger"]);

        return new className(_config);
    }
    
    /**
     * Attach this ExceptionTrap to D`s default exception handler.
     *
     * This will replace the existing exception handler, and the
     * previous exception handler will be discarded.
     * /
    void register() {
        set_exception_handler(this.handleException(...));
        register_shutdown_function(this.handleShutdown(...));
        RegisteredTrap = this;

        ini_set("assert.exception", "1");
    }
    
    /**
     * Remove this instance from the singleton
     *
     * If this instance is not currently the registered singleton nothing happens.
     * /
    void unregister() {
        if (RegisteredTrap == this) {
            this.disabled = true;
            RegisteredTrap = null;
        }
    }
    
    /**
     * Get the registered global instance if set.
     *
     * Keep in mind that the global state contained here
     * is mutable and the object returned by this method
     * could be a stale value.
     * /
    static DExceptionTrap instance(): self
    {
        return RegisteredTrap;
    }
    
    /**
     * Handle uncaught exceptions.
     *
     * Uses a template method provided by subclasses to display errors in an
     * environment appropriate way.
     * Params:
     * \Throwable anException Exception instance.
     * @throws \Exception When renderer class not found
     * @see https://secure.d.net/manual/en/function.set-exception-handler.d
     * /
    void handleException(Throwable anException) {
        if (this.disabled) {
            return;
        }
        myRequest = Router.getRequest();

        this.logException(anException, myRequest);

        try {
            event = this.dispatchEvent("Exception.beforeRender", ["exception": anException, "request": myRequest]);
            auto myException = event.getData("exception");
            assert(cast(Throwable)myException);
            
            renderer = this.renderer(myException, myRequest);
            renderer.write(event.getResult() ?? renderer.render());
        } catch (Throwable myException) {
            this.logInternalError(myException);
        }
        // Use this constant as a proxy for UIM tests.
        if (UIM_SAPI == "cli" && !enviroment("FIXTURE_SCHEMA_METADATA")) {
            exit(1);
        }
    }
    
    /**
     * Shutdown handler
     * Convert fatal errors into exceptions that we can render.
     * /
    void handleShutdown() {
        if (this.disabled) {
            return;
        }
        auto megabytes = configuration.getLong("extraFatalErrorMemory", 4);
        if (megabytes > 0) {
            this.increaseMemoryLimit(megabytes * 1024);
        }
        error = error_get_last();
        if (!error.isArray) {
            return;
        }
        fatals = [
            E_USER_ERROR,
            E_ERROR,
            E_PARSE,
        ];
        if (!in_array(error["type"], fatals, true)) {
            return;
        }
        this.handleFatalError(
            error["type"],
            error["message"],
            error["file"],
            error["line"]
        );
    }
    
    /**
     * Increases the D "memory_limit" ini setting by the specified amount
     * in kilobytes
     * Params:
     * int additionalKb Number in kilobytes
     * /
    void increaseMemoryLimit(int additionalKb) {
        aLimit = ini_get("memory_limit");
        if (aLimit == false || aLimit == "" || aLimit == "-1") {
            return;
        }
        aLimit = strip(aLimit);
        auto myUnits = strtoupper(substr(aLimit, -1));
        auto myCurrent = (int)substr(aLimit, 0, -1);
        if (myUnits == "M") {
            myCurrent *= 1024;
            myUnits = "K";
        }
        if (myUnits == "G") {
            myCurrent = myCurrent * 1024 * 1024;
            myUnits = "K";
        }
        if (myUnits == "K") {
            ini_set("memory_limit", ceil(current + additionalKb) ~ "K");
        }
    }
    
    /**
     * Display/Log a fatal error.
     * Params:
     * int code Code of error
     * @param string errorDescription Error description
     * @param string afile File on which error occurred
     * @param int line Line that triggered the error
     * /
    void handleFatalError(int code, string errorDescription, string afile, int line) {
        this.handleException(new DFatalErrorException("Fatal Error: " ~ errorDescription, 500, file, line));
    }
    
    /**
     * Log an exception.
     *
     * Primarily a auto to ensure consistency between global exception handling
     * and the ErrorHandlerMiddleware. This method will apply the `skipLog` filter
     * skipping logging if the exception should not be logged.
     *
     * After logging is attempted the `Exception.beforeRender` event is triggered.
     * Params:
     * \Throwable exception The exception to log
     * @param \Psr\Http\Message\IServerRequest|null serverRequest The optional request
     * /
    void logException(Throwable anException, ?IServerRequest serverRequest = null) {
        shouldLog = configuration.get("log"];
        if (shouldLog) {
            foreach (_configData.isSet("skipLog") as  className) {
                if (cast(className)anException) {
                    shouldLog = false;
                    break;
                }
            }
        }
        if (shouldLog) {
            this.logger().logException(anException, serverRequest, configuration.get("trace"]);
        }
    }
    
    /**
     * Trigger an error that occurred during rendering an exception.
     *
     * By triggering an E_USER_ERROR we can end up in the default
     * exception handling which will log the rendering failure,
     * and hopefully render an error page.
     * Params:
     * \Throwable logException Exception to log
     * /
    void logInternalError(Throwable logException) {
        message = 
            "[%s] %s (%s:%s)" // Keeping same message format
            .format(
                logException.classname,
                logException.getMessage(),
                logException.getFile(),
                logException.getLine(),
            );
        trigger_error(message, E_USER_ERROR);
    } */
}
