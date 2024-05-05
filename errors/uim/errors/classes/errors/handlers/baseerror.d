/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.errors.classes.errors.handlers.baseerror;

@safe:
import uim.errors;

/**
 * Base error handler that provides logic common to the CLI + web
 * error/exception handlers.
 *
 * Subclasses are required to implement the template methods to handle displaying
 * the errors in their environment.
 */
abstract class DERRErrorHandler {
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

        configuration.updateDefaults([
            "log": Json(true),
            "trace": Json(false),
            "skipLog": Json.emptyArray,
            "errorLogger": Json("ErrorLogger::class")
        ]);

        return true;
    }

    mixin(TProperty!("string", "name"));

    protected bool _handled = false;

    /**
     * Exception logger instance.
     *
     * @var uim.errors.|null
     * /
    protected IErrorLogger logger;

    /**
     * Display an error message in an environment specific way.
     *
     * Subclasses should implement this method to display the error as
     * desired for the runtime they operate in.
     *
     * @param array error An array of error data.
     * @param bool shouldDebug Whether the app is in debug mode.
     * @return void
     * /
    abstract protected void _displayError(Json[string] error, bool shouldDebug);

    /**
     * Display an exception in an environment specific way.
     *
     * Subclasses should implement this method to display an uncaught exception as
     * desired for the runtime they operate in.
     *
     * @param \Throwable exception The uncaught exception.
     * @return void
     * /
    abstract protected void _displayException(Throwable exception);

    /**
     * Register the error and exception handlers.
     * /
    void register() {
        deprecationWarning(
            "Use of `DERRErrorHandler` and subclasses are deprecated~ " ~
            "Upgrade to the new `ErrorTrap` and `ExceptionTrap` subsystem~ " ~
            "See https://book.uimD.org/4/en/appendices/4-4-migration-guide.html"
        );

        auto myLevel = _config.get("errorLevel", -1);
        error_reporting(level);
        set_error_handler([this, "handleError"], level);
        set_exception_handler([this, "handleException"]);
        register_shutdown_function(void () {
            if ((D_SAPI == "cli" || D_SAPI == "Ddbg") && _handled) {
                return;
            }
            megabytes = _config.get("extraFatalErrorMemory", 4);
            if (megabytes > 0) {
                this.increaseMemoryLimit(megabytes * 1024);
            }
            error = error_get_last();
            if (!(error.isArray) {
                return;
            }
            fatals = [
                E_USER_ERROR,
                E_ERROR,
                E_PARSE,
            ];
            if (!hasAllValues(error["type"], fatals, true)) {
                return;
            }
            this.handleFatalError(
                error["type"],
                error["message"],
                error["file"],
                error["line"]
            );
        });
    }

    /**
     * Set as the default error handler by UIM.
     *
     * Use config/error.D to customize or replace this error handler.
     * This function will use Debugger to display errors when debug mode is on. And
     * will log errors to Log, when debug mode is off.
     *
     * You can use the "errorLevel" option to set what type of errors will be handled.
     * Stack traces for errors can be enabled with the "trace" option.
     *
     * @param int code Code of error
     * @param string description Error description
     * @param string|null file File on which error occurred
     * @param int|null line Line that triggered the error
     * @param array<string, mixed>|null context DContext
     * @return bool True if error was handled
     * /
    bool handleError(
        int myCode,
        string myDescription,
        string myFile = null,
        int myLine = null,
        STRINGAA myContext = null
    ) {
        if (!(error_reporting() & myCode)) {
            return false;
        }
        _handled = true;
        [myError, myLog] = mapErrorCode(myCode);
        if (myLog == LOG_ERR) {
            /** @psalm-suppress PossiblyNullArgument * /
            return _handleFatalError(myCode, myDescription, myFile, myLine);
        }
        data = [
            "level": myLog,
            "code": myCode,
            "error": myError,
            "description": myDescription,
            "file": myFile,
            "line": myLine,
        ];

        debug = (bool)Configure::read("debug");
        if (debug) {
            // By default trim 3 frames off for the and protected methods
            // used by ErrorHandler instances.
            start = 3;

            // Can be used by error handlers that wrap other error handlers
            // to coerce the generated stack trace to the correct point.
            if (isset(context["_trace_frame_offset"])) {
                start += context["_trace_frame_offset"];
                unset(context["_trace_frame_offset"]);
            }
            data += [
                "context": context,
                "start": start,
                "path": Debugger::trimPath((string)file),
            ];
        }
        _displayError(data, debug);
        _logError(log, data);

        return true;
    }


    /**
     * Handle uncaught exceptions.
     *
     * Uses a template method provided by subclasses to display errors in an
     * environment appropriate way.
     *
     * @param \Throwable exception Exception instance.
     * @return void
     * @throws \Exception When renderer class not found
     * @see https://secure.D.net/manual/en/function.set-exception-handler.D
     * /
    void handleException(Throwable exception) {
        _displayException(exception);
        this.logException(exception);
        code = exception.getCode() ?: 1;
        _stop((int)code);
    }

    /**
     * Stop the process.
     *
     * Implemented in subclasses that need it.
     *
     * @param int code Exit code.
     * /
    protected void _stop(int code) {
        // Do nothing.
    }

    /**
     * Display/Log a fatal error.
     *
     * @param int code Code of error
     * @param string description Error description
     * @param string file File on which error occurred
     * @param int line Line that triggered the error
     * /
    bool handleFatalError(int code, string description, string file, int line) {
        data = [
            "code": code,
            "description": description,
            "file": file,
            "line": line,
            "error": "Fatal Error",
        ];
        _logError(LOG_ERR, data);

        this.handleException(new DFatalErrorException(description, 500, file, line));

        return true;
    }

    /**
     * Increases the D "memory_limit" ini setting by the specified amount
     * in kilobytes
     *
     * @param int additionalKb Number in kilobytes
     * /
    void increaseMemoryLimit(int additionalKb) {
        limit = ini_get("memory_limit");
        if (limit == false || limit == "" || limit == "-1") {
            return;
        }
        limit = strip(limit);
        units = (substr(limit, -1)).toUpper;
        current = (int)substr(limit, 0, strlen(limit) - 1);
        if (units == "M") {
            current *= 1024;
            units = "K";
        }
        if (units == "G") {
            current = current * 1024 * 1024;
            units = "K";
        }

        if (units == "K") {
            ini_set("memory_limit", ceil(current + additionalKb) ~ "K");
        }
    }

    /**
     * Log an error.
     *
     * @param string|int level The level name of the log.
     * @param array data Array of error data.
     * /
    protected bool _logError(level, array data) {
        message = sprintf(
            "%s (%s): %s in [%s, line %s]",
            data["error"],
            data["code"],
            data["description"],
            data["file"],
            data["line"]
        );
        context = null;
        if (!empty(_config["trace"])) {
            context["trace"] = Debugger::trace([
                "start": 1,
                "format": "log",
            ]);
            context["request"] = Router::getRequest();
        }

        return _getLogger().logMessage(level, message, context);
    }

    /**
     * Log an error for the exception if applicable.
     *
     * @param \Throwable exception The exception to log a message for.
     * @param \Psr\Http\messages.IServerRequest|null request The current request.
     * /
    bool logException(Throwable exception, ?IServerRequest request = null) {
        if (empty(_config["log"])) {
            return false;
        }
        foreach (_config["skipLog"] as aClassName) {
            if (exception instanceof aClassName) {
                return false;
            }
        }

        return _getLogger().log(exception, request ?? Router::getRequest());
    }

    /**
     * Get exception logger.
     *
     * @return uim.errors.IErrorLogger
     * /
    function getLogger() {
        if (this.logger == null) {
            /** @var uim.errors.IErrorLogger logger * /
            logger = new _config["errorLogger"](_config);

            if (!logger instanceof IErrorLogger) {
                // Set the logger so that the next error can be logged.
                this.logger = new DErrorLogger(_config);

                interface = IErrorLogger::class;
                type = getTypeName(logger);
                throw new DRuntimeException("Cannot create logger. `{type}` does not implement `{interface}`.");
            }
            this.logger = logger;
        }

        return _logger;
    }

    /**
     * Map an error code into an Error word, and log location.
     *
     * @param int code Error code to map
     * @return array Array of error word, and log location.
     * /
    static array mapErrorCode(int code) {
        levelMap = [
            E_PARSE: "error",
            E_ERROR: "error",
            E_CORE_ERROR: "error",
            E_COMPILE_ERROR: "error",
            E_USER_ERROR: "error",
            E_WARNING: "warning",
            E_USER_WARNING: "warning",
            E_COMPILE_WARNING: "warning",
            E_RECOVERABLE_ERROR: "warning",
            E_NOTICE: "notice",
            E_USER_NOTICE: "notice",
            E_STRICT: "strict",
            E_DEPRECATED: "deprecated",
            E_USER_DEPRECATED: "deprecated",
        ];
        logMap = [
            "error": LOG_ERR,
            "warning": LOG_WARNING,
            "notice": LOG_NOTICE,
            "strict": LOG_NOTICE,
            "deprecated": LOG_NOTICE,
        ];

        error = levelMap[code];
        log = logMap[error];

        return [ucfirst(error), log];
    } */
}
