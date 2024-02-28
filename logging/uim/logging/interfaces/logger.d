module uim.logging.interfaces.logger;

import uim.logging;

@safe:

interface ILogger : INamed {
    // Get the levels this logger is interested in.
    string[] levels();

    // Get the scopes this logger is interested in.
    string[] scopes();
}
