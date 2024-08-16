module uim.oop.logging.engines.console;

import uim.oop;
 
@safe:
// Console logging. Writes logs to console output.
class DConsoleLogEngine : DLogEngine {
    mixin(LogEngineThis!("Console"));
}
mixin(LogEngineCalls!("Console"));
