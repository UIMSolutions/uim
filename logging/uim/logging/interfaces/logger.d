module uim.logging.interfaces.logger;

import uim.logging;

@safe:

interface ILogger : INamed {
    // Get the levels this logger is interested in.
    string[] levels();

    // Get the scopes this logger is interested in.
    string[] scopes();

    /*
    
    // System is unusable.
    void emergency(string aMessage, STRINGAA aContext = null);

    // Action must be taken immediately.
    // Example: Entire website down, database unavailable, etc. This should trigger the SMS alerts and wake you up.
    void alert(string aMessage, STRINGAA aContext = null);

    // Critical conditions.
    // Example: Application component unavailable, unexpected exception.
    void critical(string aMessage, STRINGAA aContext = null);

    // Runtime errors that do not require immediate action but should typically be logged and monitored.
    void error(string aMessage, STRINGAA aContext = null);

    // Exceptional occurrences that are not errors.
    // Example: Use of deprecated APIs, poor use of an API, undesirable things that are not necessarily wrong.
    void warning(string aMessage, STRINGAA aContext = null);

    // Normal but significant events.
    void notice(string aMessage, STRINGAA aContext = null);

    // Interesting events
    // Example: User logs in, SQL logs.
    void info(string aMessage, STRINGAA aContext = null);

    //Detailed debug information.
    void debugInfo(string aMessage, STRINGAA aContext = null);

    // Logs with an arbitrary level.
    void log(LogLevels aLevel, string aMessage, STRINGAA aContext = null);
*/

}
