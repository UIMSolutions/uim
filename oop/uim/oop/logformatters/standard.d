module uim.oop.logformatters.standard;

import uim.oop;
@safe:

// Base class for LogFormatters
class DStandardLogFormatter : DLogFormatter {
    mixin(LogFormatterThis!("Standard"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }
}
mixin(LogFormatterCalls!("Standard"));
