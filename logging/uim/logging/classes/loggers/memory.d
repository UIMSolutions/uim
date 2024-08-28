module uim.logging.loggers.memory;

import uim.oop;

@safe:
/**
 * Array logger.
 *
 * Collects log messages in memory. Intended primarily for usage
 * in testing where using mocks would be complicated. But can also
 * be used in scenarios where you need to capture logs in application code.
 */
class DMemoryLogger : DLogger {
    mixin(LoggerThis!("Memory"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration
            .setDefault("levels", Json.emptyArray)
            .setDefault("scopes", Json.emptyArray)
            .setDefault("formatter",
                createMap!(string, Json)
                    .set("classname", StandardLogFormatter.classname)
                    .set("includeDate", false));

        return true;
    }

    // Captured messages
    protected string[] _content;

    // Writing to the internal storage.
    override ILogger log(LogLevels logLevel, string logMessage, Json[string] logContext = null) {
        auto interpolatedMessage = interpolate(logMessage, logContext);
        // TODO _content ~= _formatter.format(logLevel, interpolatedMessage, logContext);
        return this;
    }

    // Read the internal storage
    string[] read() {
        return _content;
    }

    // Reset internal storage.
    void clear() {
        _content = null;
    }
}
mixin(LoggerCalls!("Memory"));
