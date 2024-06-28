module oop.uim.oop.loggers.logger;

import uim.oop;
@safe:

class DLogger : UIMObject, ILogger {
    mixin(LoggerThis!(""));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }
}