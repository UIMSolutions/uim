module uim.oop.logformatters.logformatter;

import uim.oop;
@safe:

// Base class for LogFormatters
class DLogFormatter : UIMObject, ILogFormatter {
/*     mixin TLocatorAware;
    mixin TLog; */

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }
}
