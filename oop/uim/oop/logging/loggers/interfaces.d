module uim.oop.logging.loggers.interfaces;

import uim.oop;
@safe:

interface ILogger : INamed {
    // Get the levels this logger is interested in.
    string[] levels();

    // Get the scopes this logger is interested in.
    string[] scopes();

    // Logs with an arbitrary level.
    void log(LogLevels logLevel, string logMessage, Json[string] logContext = null); 

    /*
    
    // System is unusable.
    void emergency(string logMessage, Json[string] logContext = null);

    // Action must be taken immediately.
    // Example: Entire website down, database unavailable, etc. This should trigger the SMS alerts and wake you up.
    void alert(string logMessage, Json[string] logContext = null);

    // Critical conditions.
    // Example: Application component unavailable, unexpected exception.
    void critical(string logMessage, Json[string] logContext = null);

    // Runtime errors that do not require immediate action but should typically be logged and monitored.
    void error(string logMessage, Json[string] logContext = null);

    // Exceptional occurrences that are not errors.
    // Example: Use of deprecated APIs, poor use of an API, undesirable things that are not necessarily wrong.
    void warning(string logMessage, Json[string] logContext = null);

    // Normal but significant events.
    void notice(string logMessage, Json[string] logContext = null);

    // Interesting events
    // Example: User logs in, SQL logs.
    void info(string logMessage, Json[string] logContext = null);

    //Detailed debug information.
    void debugInfo(string logMessage, Json[string] logContext = null); */
}