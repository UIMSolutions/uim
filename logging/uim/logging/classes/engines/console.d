module uim.logging.classes.engines.console;

import uim.logging;
 
@safe:
// Console logging. Writes logs to console output.
class DConsoleLogEngine : DLogEngine {
    mixin(LogEngineThis!("Console"));
}
mixin(LogEngineCalls!("Console"));
