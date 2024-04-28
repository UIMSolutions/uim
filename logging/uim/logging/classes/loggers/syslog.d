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
     *     "engine": "Syslog",
     *     "levels": ["emergency", "alert", "critical", "error"],
     *     "prefix": "Web Server 01"
     * ]);
     * ```
     *
     * /
    configuration.updateDefaults([
        "levels": Json.emptyArray,
        "scopes": Json.emptyArray,
        "flag": LOG_ODELAY,
        "prefix": "",
        "facility": LOG_USER,
        "formatter": [
            "className": DefaultFormatter.classname,
            "includeDate": BooleanData(false),
        ],
    ];

    // Used to map the string names back to their LOG_* constants
    protected int[string] _levelMap = [
        "emergency": LOG_EMERG,
        "alert": LOG_ALERT,
        "critical": LOG_CRIT,
        "error": LOG_ERR,
        "warning": LOG_WARNING,
        "notice": LOG_NOTICE,
        "info": LOG_INFO,
        "debug": LOG_DEBUG,
    ];

    // Whether the logger connection is open or not
    protected bool _open = false;

    /**
     * Writes a message to syslog
     *
     * Map the level back to a LOG_constant value, split multi-line messages into multiple
     * log messages, pass all messages through the format defined in the configuration
     * Params:
     * Json level The severity level of log you are making.
     * @param \string messageToLog The message you want to log.
     * @param array context Additional information about the logged message
     * /
    void log(level, string messageToLog, array context = []) {
        if (!_open) {
            configData = configuration;
           _open(configuration.get("prefix"), configuration.get("flag"], configuration.get("facility"]);
           _open = true;
        }
        priority = LOG_DEBUG;
        if (_levelMap.isSet(level)) {
            priority = _levelMap[level];
        }
        auto myLines = this.interpolate(messageToLog, context).split("\n");
        myLines.each!(line => _write(priority, this.formatter.format(level, line, context)));
    }
    
    /**
     * Extracts the call to openlog() in order to run unit tests on it. This function
     * will initialize the connection to the system logger
     * Params:
     * string aident the prefix to add to all messages logged
     * @param int options the options flags to be used for logged messages
     * @param int facility the stream or facility to log to
     * /
    protected void _open(string aident, int options, int facility) {
        openlog(anIdent, options, facility);
    }
    
    /**
     * Extracts the call to syslog() in order to run unit tests on it. This function
     * will perform the actual write in the system logger
     * Params:
     * int priority Message priority.
     * @param string messageToLog Message to log.
     * /
    protected bool _write(int priority, string messageToLog) {
        return syslog(priority, message);
    }
    
    // Closes the logger connection
    auto __destruct() {
        closelog();
    } */
}
