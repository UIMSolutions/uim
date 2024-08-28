module uim.logging.classes.loggers.syslog;

import uim.logging;

@safe:

// Syslog stream for Logging. Writes logs to the system logger
class DSysLogger : DLogger {
    mixin(LoggerThis!("Sys"));
    /**
     * Default config for this class
     *
     * By default messages are formatted as:
     * level: message
     *
     * To override the log format (e.g. to add your own info) define the format key when configuring
     * this logger
     *
     * If you wish to include a prefix to all messages, for instance to identify the
     * application or the web server, then use the prefix option. Please keep in mind
     * the prefix is shared by all streams using syslog, as it is dependent of
     * the running process. For a local prefix, to be used only by one stream, you
     * can use the format key.
     *
     * ### Example:
     *
     * ```
     * Log.config("error", ]
     *    "engine": "Syslog",
     *    "levels": ["emergency", "alert", "critical", "error"],
     *    "prefix": "Web Server 01"
     * ]);
     * ```
     */

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }    
        
        configuration
        .setDefault("levels", Json.emptyArray)
        .setDefault("scopes", Json.emptyArray)
        //.setDefault("flag", LOG_ODELAY)
        .setDefault("prefix", "")
        // .setDefault("facility", LOG_USER)
        .setDefault("formatter", createMap!(string, Json)
            .set("classname", StandardLogFormatter.classname)
            .set("includeDate", false)
        );

        return true; 
    }
    // Used to map the string names back to their LOG_* constants
    protected int[string] _levelMap;/*  = [
        "emergency": LOG_EMERG,
        "alert": LOG_ALERT,
        "critical": LOG_CRIT,
        "error": LOGS.ERROR,
        "warning": LOGS.WARNING,
        "notice": LOGS.NOTICE,
        "info": LOG_INFO,
        "debug": LOG_DEBUG,
    ]; */

    // Whether the logger connection is open or not
    protected bool _open = false;

    /**
     * Writes a message to syslog
     *
     * Map the level back to a LOG_constant value, split multi-line messages into multiple
     * log messages, pass all messages through the format defined in the configuration
     */
    void log(Json severityLevel, string messageToLog, Json[string] context = null) {
        if (!_open) {
            /* configData = configuration;
           _open(configuration.get("prefix"), configuration.get("flag"), configuration.get("facility"));
           _open = true; */
        }
        /* auto priority = LOG_DEBUG;
        if (_levelMap.hasKey(severityLevel)) {
            priority = _levelMap[level];
        } */
        /* interpolate(messageToLog, context).split("\n")
            .each!(line => _write(priority, _formatter.format(severityLevel, line, context))); */
    }
    
    /**
     * Extracts the call to openlog() in order to run unit tests on it. This function
     * will initialize the connection to the system logger
     */
/*     protected void _open(string idPrefix, uLong optionFlags, int facility) {
        openlog(idPrefix, optionFlags, facility);
    } */
    
    /**
     * Extracts the call to syslog() in order to run unit tests on it. This function
     * will perform the actual write in the system logger
     */
    protected bool _write(int priority, string logMessage) {
        /* return syslog(priority, logMessage); */
        return false;
    }
    
    // Closes the logger connection
    auto __destruct() {
       /*  closelog(); */
    }

  override ILogger log(LogLevels logLevel, string logMessage, Json[string] logContext = null) {
    return this; 
  }
}
mixin(LoggerCalls!("Sys"));
