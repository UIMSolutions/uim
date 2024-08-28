module uim.logging.engines.file;

import uim.oop;

@safe:
// File Storage stream for Logging. Writes logs to different files based on the level of log it is.
class DFileLogEngine : DLogEngine {
    mixin(LogEngineThis!("File"));
}
mixin(LogEngineCalls!("File"));