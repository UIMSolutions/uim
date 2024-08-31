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
        configuration.setDefault("trace", false); // `trace` = Should error logs include stack traces?
        
        return true;
    }

    void logError(UIMError error, IServerRequest serverRequest = null, bool anIncludeTrace = false) {
        auto errorMessage = error.message();
        if (request) {
            errorMessage ~= getRequestContext(request);
        }
        if (anIncludeTrace) {
            errorMessage ~= "\nTrace:\n" ~ error.getTraceAsString() ~ "\n";
        }
        /* label = error.getLabel();
        level = match (label) {
            "strict": LOGS.NOTICE,
            "deprecated": LOG_DEBUG,
            default: label,
        };

        Log.write(level, errorMessage); */
    }
 
    void logException(
        Throwable exception,
        IServerRequest serverRequest = null,
        bool anIncludeTrace = false
   ) {
        exceptionMessage = message(exception, false,  anIncludeTrace);

        if (!request.isNull) {
            exceptionMessage ~= getRequestContext(request);
        }
        Log.error(exceptionMessage);
    }
    
    // Generate the message for the exception
    protected string message(Throwable exceptionToLog, bool isPrevious = false, bool includeTrace = false) {
        string message = "%s[%s] %s in %s on line %s"
            .format(
                isPrevious ? "\nCaused by: " : "",
                exceptionToLog.classname,
                exceptionToLog.message(),
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
            message ~= message(previousException, true,  includeTrace);
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
