module uim.oop.logging.log;

import uim.oop;

@safe:

/**
 * Logs messages to configured Log adapters. One or more adapters
 * can be configured using uim Logs"s methods. If you don"t
 * configure any adapters, and write to Log, the messages will be
 * ignored.
 *
 * ### Configuring Log adapters
 *
 * You can configure log adapters in your applications `config/app.d` file.
 * A sample configuration would look like:
 *
 * ```
 * Log.configuration.set("_log", ["classname": "FileLog"]);
 * ```
 *
 * You can define the classname as any fully namespaced classname or use a short hand
 * classname to use loggers in the `App\Log\Engine` & `UIM\Log\Engine` namespaces.
 * You can also use plugin short hand to use logging classes provided by plugins.
 *
 * Log adapters are required to implement `Psr\Log\ILogger`, and there is a
 * built-in base class (`UIM\Log\Engine\BaseLog`) that can be used for custom loggers.
 *
 * Outside of the `classname` key, all other configuration values will be passed to the
 * logging adapter"s constructor as an array.
 *
 * ### Logging levels
 *
 * When configuring loggers, you can set which levels a logger will handle.
 * This allows you to disable debug messages in production for example:
 *
 * ```
 * Log.configuration.set("default", [
 *   "classname": "File",
 *   "path": LOGS,
 *   "levels": ["error", "critical", "alert", "emergency"]
 * ]);
 * ```
 *
 * The above logger would only log error messages or higher. Any
 * other log messages would be discarded.
 *
 * ### Logging scopes
 *
 * When configuring loggers you can define the active scopes the logger
 * is for. If defined, only the listed scopes will be handled by the
 * logger. If you don"t define any scopes an adapter will catch
 * all scopes that match the handled levels.
 *
 * ```
 * Log.configuration.set("payments", [
 *   "classname": "File",
 *   "scopes": ["payment", "order"]
 * ]);
 * ```
 *
 * The above logger will only capture log entries made in the
 * `payment` and `order` scopes. All other scopes including the
 * undefined scope will be ignored.
 *
 * ### Writing to the log
 *
 * You write to the logs using Log.write(). See its documentation for more information.
 *
 * ### Logging Levels
 *
 * By default uim Log supports all the log levels defined in
 * RFC 5424. When logging messages you can either use the named methods,
 * or the correct constants with `write()`:
 *
 * ```
 * Log.error("Something horrible happened");
 * Log.write(LOGS.ERROR, "Something horrible happened");
 * ```
 *
 * ### Logging scopes
 *
 * When logging messages and configuring log adapters, you can specify
 * "scopes" that the logger will handle. You can think of scopes as subsystems
 * in your application that may require different logging setups. For
 * example in an e-commerce application you may want to handle logged errors
 * in the cart and ordering subsystems differently than the rest of the
 * application. By using scopes you can control logging for each part
 * of your application and also use standard log levels.
 */
class DLog {
    // Internal flag for tracking whether configuration has been changed.
    protected static bool _isDirtyConfig = false;

    protected static DLogEngineRegistry _registry;

    /* 
    mixin template TStaticConfig() {
        setConfig as protected _setConfig;
    } */
    
    // An array mapping url schemes to fully qualified Log engine class names
    protected static STRINGAA _dsnClassMap = [
        "console": ConsoleLog.classname,
        "file": FileLog.classname,
        "syslog": SyslogLog.classname,
    ];


    // Handled log levels
    protected static string[] _levels = [
        "emergency",
        "alert",
        "critical",
        "error",
        "warning",
        "notice",
        "info",
        "debug",
    ];

    /**
     * Log levels as detailed in RFC 5424
     * https://tools.ietf.org/html/rfc5424
     *
     * @var array<string, int>
     */
    protected static Json[string] _levelMap = [
        "emergency": LOG_EMERG,
        "alert": LOG_ALERT,
        "critical": LOG_CRIT,
        "error": LOGS.ERROR,
        "warning": LOGS.WARNING,
        "notice": LOGS.NOTICE,
        "info": LOG_INFO,
        "debug": LOG_DEBUG,
    ];

    /**
     * Creates registry if doesn"t exist and creates all defined logging
     * adapters if config isn"t loaded.
     */
    protected static LogEngineRegistry getRegistry() {
        _registry = _registry ? _registry : new DLogEngineRegistry();

        if (_isDirtyConfig) {
            foreach (name, properties; configuration) {
                if (properties.hasKey("engine")) {
                    properties.set("classname", properties.get("engine"));
                }
                if (!_registry.hasKey(to!string(name))) {
                    _registry.load(to!string(name, properties));
                }
            }
        }
        _isDirtyConfig = false;

        return _registry;
    }
    
    /**
     * Reset all the connected loggers. This is useful to do when changing the logging
     * configuration or during testing when you want to reset the internal state of the
     * Log class.
     *
     * Resets the configured logging adapters, as well as any custom logging levels.
     * This will also clear the configuration data.
     */
    static void reset() {
        if (isSet(_registry)) {
            _registry.reset();
        }
        configuration = null;
        _isDirtyConfig = true;
    }
    
    /**
     * Gets log levels
     *
     * Call this method to obtain current
     * level configuration.
     */
    static string[] levels() {
        return _levels;
    }
    
    /**
     * This method can be used to define logging adapters for an application
     * or read existing configuration.
     *
     * To change an adapter"s configuration at runtime, first drop the adapter and then
     * reconfigure it.
     *
     * Loggers will not be constructed until the first log message is written.
     *
     * ### Usage
     *
     * Setting a cache engine up.
     *
     * ```
     * Log.configuration.set("default", settings);
     * ```
     *
     * Injecting a constructed adapter in:
     *
     * ```
     * Log.configuration.set("default",  anInstance);
     * ```
     *
     * Using a factory auto to get an adapter:
     *
     * ```
     * Log.configuration.set("default", auto () { return new DFileLog(); });
     * ```
     *
     * Configure multiple adapters at once:
     *
     * ```
     * Log.configuration.set(arrayOfConfig);
     * ```
     */
    static void configurationSet(string[] configName, /* ILogger|Closure|array|null */ Json[string] configData = null) {
        configuration.set(configName, configData);
        _isDirtyConfig = true;
    }
    
    // Get a logging engine.
    static ILogger engine(string adapterName) {
        auto registry = getRegistry();

        return null;      
/*         return !registry.{adapterName}
            ? null
            : registry.{adapterName};
 */    }
    
    /**
     * Writes the given message and type to all the configured log adapters.
     * Configured adapters are passed both the level and message variables. level
     * is one of the following strings/values.
     *
     * ### Levels:
     *
     * - `LOG_EMERG`: "emergency",
     * - `LOG_ALERT`: "alert",
     * - `LOG_CRIT`: "critical",
     * - `LOGS.ERROR`: "error",
     * - `LOGS.WARNING`: "warning",
     * - `LOGS.NOTICE`: "notice",
     * - `LOG_INFO`: "info",
     * - `LOG_DEBUG`: "debug",
     *
     * ### Basic usage
     *
     * Write a "warning" message to the logs:
     *
     * ```
     * Log.write("warning", "Stuff is broken here");
     * ```
     *
     * ### Using scopes
     *
     * When writing a log message you can define one or many scopes for the message.
     * This allows you to handle messages differently based on application section/feature.
     *
     * ```
     * Log.write("warning", "Payment failed", ["scope": "payment"]);
     * ```
     *
     * When configuring loggers you can configure the scopes a particular logger will handle.
     * When using scopes, you must ensure that the level of the message, and the scope of the message
     * intersect with the defined levels & scopes for a logger.
     *
     * ### Unhandled log messages
     *
     * If no configured logger can handle a log message (because of level or scope restrictions)
     * then the logged message will be ignored and silently dropped. You can check if this has happened
     * by inspecting the return of write(). If false the message was not handled.
     */
    static bool write(int severityLevel, string messageToLog, string[] contextData = null) {
        /* return isIn(severityLevel, _levelMap, true)
            ? write(array_search(severityLevel, _levelMap, true), messageToLog, contextData) {
            : false;  */
        return false;
    }

    static bool write(string severityLevel, string messageToLog, string[] contextData = null) {
        if (!isIn(severityLevel, _levels, true)) {
            /** @psalm-suppress PossiblyFalseArgument */
            throw new DInvalidArgumentException(
                "Invalid log level `%s`".format(level));
        }
        auto logged = false;
        auto contextArray = /* (array) */contextData;
        if (isSet(contextArray[0])) {
            contextArray = ["scope": contextArray];
        }
        contextData ~= ["scope": Json.emptyArray];

        auto registry = getRegistry();
        registry.loaded().each!((streamName) {
            /* ILogger logger = registry.{streamName};
            auto levels = scopes = null;

            if (cast(BaseLog)logger) {
                levels = logger.levels();
                scopes = logger.scopes();
            }
            auto correctLevel = levels.isEmpty || isIn(severityLevel, levels, true);
             anInScope = scopes.isNull && contextData.isEmpty("scope") || scopes is null ||
                isArray(scopes) && intersect(/* (array) * /contextData["scope"], scopes);

            if (correctLevel &&  anInScope) {
                logger.log(severityLevel, messageToLog, contextData);
                logged = true;
            } */
        });
        return logged;
    }
    
    /**
     * Convenience method to log emergency messages
     * Params:
     * The special `scope` key can be passed to be used for further filtering of the
     * log engines to be used. If a string or a numerically index array is passed, it
     * will be treated as the `scope` key.
     */
    static bool emergency(string logMessage, string[] context = null) {
        return write(__FUNCTION__, logMessage, context);
    }
    
    // Convenience method to log alert messages
    static bool alert(string logMessage, string[] contextData = null) {
        return write(__FUNCTION__, logMessage, contextData);
    }
    
    // Convenience method to log critical messages
    static bool critical(string logMessage, string[] context = null) {
        return write(__FUNCTION__, logMessage, context);
    }
    
    // Convenience method to log error messages
    static bool error(string logMessage, string[] contextData = null) {
        return write(__FUNCTION__, logMessage, contextData);
    }
    
    // Convenience method to log warning messages
    static bool warning(string logMessage, string[] context = null) {
        return write(__FUNCTION__, logMessage, context);
    }
    
    // Convenience method to log notice messages
    static bool notice(string logMessage, string[] contextData = null) {
        return write(__FUNCTION__, logMessage, context);
    }
    
    // Convenience method to log debug messages
    static bool shouldDebug(string logMessage, string[] dataForLoggingMessage= null) {
        return write(__FUNCTION__, logMessage, dataForLoggingMessage);
    }
    
    /**
     * Convenience method to log info messages
     * The special `scope` key can be passed to be used for further filtering of the
     * log engines to be used. If a string or a numerically indexed array is passed, it
     * will be treated as the `scope` key.
     */
    static bool info(string logMessage, string[] contextData = null) {
        return write(__FUNCTION__, logMessage, contextData);
    }
}