module uim.errors.classes.errorlogger;

import uim.errors;

@safe:

/**
 * Log errors and unhandled exceptions to `UIM\Log\Log`
 */
class ErrorLogger { // }: IErrorLogger {
    /*
    use InstanceConfigTemplate();

    /**
     * Default configuration values.
     *
     * - `trace` Should error logs include stack traces?
     *
     * /
    protected IData[string] _defaultConfigData = [
        "trace": false,
    ];

    /**
     * Constructor
     * Params:
     * IData[string] configData Config array.
     * /
    this(IData[string] configData = null) {
        this.setConfig(configData);
    }
  /*
    void logError(UimError error, ?IServerRequest serverRequest = null, bool  anIncludeTrace = false) {
        auto errorMessage = error.getMessage();
        if (request) {
            errorMessage ~= this.getRequestContext(request);
        }
        if (anIncludeTrace) {
            errorMessage ~= "\nTrace:\n" ~ error.getTraceAsString() ~ "\n";
        }
        label = error.getLabel();
        level = match (label) {
            "strict": LOG_NOTICE,
            "deprecated": LOG_DEBUG,
            default: label,
        };

        Log.write(level, errorMessage);
    }
 
    void logException(
        Throwable exception,
        ?IServerRequest serverRequest = null,
        bool  anIncludeTrace = false
    ) {
        exceptionMessage = this.getMessage(exception, false,  anIncludeTrace);

        if (request !isNull) {
            exceptionMessage ~= this.getRequestContext(request);
        }
        Log.error(exceptionMessage);
    }
    
    /**
     * Generate the message for the exception
     * Params:
     * \Throwable exception The exception to log a message for.
     * @param bool  isPrevious False for original exception, true for previous
     * @param bool  anIncludeTrace Whether or not to include a stack trace.
     * /
    protected string getMessage(Throwable exception, bool  isPrevious = false, bool  anIncludeTrace = false) {
        string message = "%s[%s] %s in %s on line %s"
            .format(
                isPrevious ? "\nCaused by: " : "",
                exception.classname,
                exception.getMessage(),
                exception.getFile(),
                exception.getLine()
            );

        debug = Configure.read("debug");

        if (debug && cast(UimException)exception) {
            attributes = exception.getAttributes();
            if (attributes) {
                message ~= "\nException Attributes: " ~ var_export(exception.getAttributes(), true);
            }
        }
        if (anIncludeTrace) {
            trace = Debugger.formatTrace(exception, ["format": "points"]);
            assert(isArray(trace));
            message ~= "\nStack Trace:\n";
            trace.each!((line) {
                message ~= isString(line)
                    ? "- " ~ line
                    : "- {line["file"]}:{line["line"]}\n";
            });
        }

        auto previousException = exception.getPrevious();
        if (previousException) {
            message ~= this.getMessage(previousException, true,  anIncludeTrace);
        }
        return message;
    }
    
    /**
     * Get the request context for an error/exception trace.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest The request to read from.
     * /
    string getRequestContext(IServerRequest serverRequest) {
        string message = "\nRequest URL: " ~ request.getRequestTarget();

        referer = request.getHeaderLine("Referer");
        if (referer) {
            message ~= "\nReferer URL: " ~ referer;
        }
        if (cast(ServerRequest)request) {
            clientIp = request.clientIp();
            if (clientIp && clientIp != ".1") {
                message ~= "\nClient IP: " ~ clientIp;
            }
        }
        return message;
    } */
}
