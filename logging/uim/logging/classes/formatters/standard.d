module uim.logging.classes.formatters.standard;

import uim.logging;

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

    override string format(LogLevels logLevel, string logMessage, Json[string] logData = null) {
        string result = logMessage;
        // TODO
        return result;
    }
}

mixin(LogFormatterCalls!("Standard"));
