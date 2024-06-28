 module uim.logging.classes.loggers.array;

import uim.logging;

@safe:

/**
 * Array logger.
 *
 * Collects log messages in memory. Intended primarily for usage
 * in testing where using mocks would be complicated. But can also
 * be used in scenarios where you need to capture logs in application code.
 */
class DArrayLogger : DLogger { 
    /*
    configuration.updateDefaults([
        "levels": Json.emptyArray,
        "scopes": Json.emptyArray,
        "formatter": [
            "className": DefaultLogFormatter.classname,
            "includeDate": false.toJson
        ]
    ];

    // Captured messages
    protected string[] _content;

    // writing to the internal storage.
    void log(Json logLevel, string logMessage, Json[string] messageContext = null) {
        logMessage = this.interpolate(logMessage, messageContext);
        _content ~= this.formatter.format(logLevel, logMessage, messageContext);
    }

    // Read the internal storage
    string[] read() {
        return _content;
    }
    
    // Reset internal storage.
    void clear() {
        this.content = null;
    }
}
