module uim.errors.classes.errorlogger;

import uim.errors;

@safe:

// Log errors and unhandled exceptions to `UIM\Log\Log`
class DErrorLogger : IErrorLogger {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);
        configuration.updateDefaults([
            // `trace` = Should error logs include stack traces?
            "trace":  false.toJson,
        ]);
        
        return true;
    }

    void logError(UimError error, IServerRequest serverRequest = null, bool anIncludeTrace = false) {
        auto errorMessage = error.getMessage();
        if (request) {
            errorMessage ~= getRequestContext(request);
        }
        if (anIncludeTrace) {
            errorMessage ~= "\nTrace:\n" ~ error.getTraceAsString() ~ "\n";
        }
        label = error.getLabel();
        level = match (label) {
            "strict":  LOG_NOTICE,
            "deprecated":  LOG_DEBUG,
            default: label,
        };

        Log.write(level, errorMessage);
    }
 
    void logException(
        Throwable exception,
        IServerRequest serverRequest = null,
        bool anIncludeTrace = false
    ) {
        exceptionMessage = getMessage(exception, false,  anIncludeTrace);

        if (!request.isNull) {
            exceptionMessage ~= getRequestContext(request);
        }
        Log.error(exceptionMessage);
    }
    
    /**
     * Generate the message for the exception
     * Params:
     * \Throwable exception The exception to log a message for.
     * @param bool anIncludeTrace Whether or not to include a stack trace.
     */
    protected string getMessage(Throwable exception, bool isPrevious = false, bool anIncludeTrace = false) {
        string message = "%s[%s] %s in %s on line %s"
            .format(
                isPrevious ? "\nCaused by: " : "",
                exception.classname,
                exception.getMessage(),
                exception.getFile(),
                exception.getLine()
            );

        debug = configuration.get("debug");

        if (debug && cast(UimException)exception) {
            attributes = exception.getAttributes();
            if (attributes) {
                message ~= "\nException Attributes: " ~ var_export_(exception.getAttributes(), true);
            }
        }
        if (anIncludeTrace) {
            trace = Debugger.formatTrace(exception, ["format":  "points"]);
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
            message ~= getMessage(previousException, true,  anIncludeTrace);
        }
        return message;
    }
    
    /**
     * Get the request context for an error/exception trace.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest The request to read from.
     */
    string getRequestContext(IServerRequest serverRequest) {
        string message = "\nRequest URL: " ~ request.getRequestTarget();

        referer = request.getHeaderLine("Referer");
        if (referer) {
            message ~= "\nReferer URL: " ~ referer;
        }
        if (cast(DServerRequest)request) {
            clientIp = request.clientIp();
            if (clientIp && clientIp != ".1") {
                message ~= "\nClient IP: " ~ clientIp;
            }
        }
        return message;
    } */
}
