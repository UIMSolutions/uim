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
            "trace": false.toJson,
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
            "strict": LOG_NOTICE,
            "deprecated": LOG_DEBUG,
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
    
    // Generate the message for the exception
    protected string getMessage(Throwable exceptionToLog, bool isPrevious = false, bool includeTrace = false) {
        string message = "%s[%s] %s in %s on line %s"
            .format(
                isPrevious ? "\nCaused by: " : "",
                exceptionToLog.classname,
                exceptionToLog.getMessage(),
                exceptionToLog.getFile(),
                exceptionToLog.getLine()
            );

        debug = configuration.get("debug");

        if (debug && cast(DException)exceptionToLog) {
            attributes = exceptionToLog.getAttributes();
            if (attributes) {
                message ~= "\nException Attributes: " ~ var_export_(exceptionToLog.getAttributes(), true);
            }
        }
        if (includeTrace) {
            trace = Debugger.formatTrace(exceptionToLog, ["format": "points"]);
            assert(isArray(trace));
            message ~= "\nStack Trace:\n";
            trace.each!((line) {
                message ~= isString(line)
                    ? "- " ~ line
                    : "- {line["file"]}:{line["line"]}\n";
            });
        }

        auto previousException = exceptionToLog.getPrevious();
        if (previousException) {
            message ~= getMessage(previousException, true,  includeTrace);
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
