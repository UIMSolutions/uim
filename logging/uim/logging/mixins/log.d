 module uim.logging.mixins.log;

import uim.logging;

@safe:
// Template providing an object short-cut method to logging.
mixin template TLog() {
    /**
     * Convenience method to write a message to Log. See Log.write()
     * for more information on writing to logs.
     */
    bool log(string logMessage,
        LOGLEVELS errorLevel = LOGLEVELS.ERROR,
        Json[string] logData = null
   ) {
        return Log.write(errorLevel, logMessage, logData);
    }
}
