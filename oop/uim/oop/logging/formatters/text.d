module uim.oop.logging.formatters.text;

import uim.oop;

@safe:
class DTextLogFormatter : DLogFormatter {
    mixin(LogFormatterThis!("Text"));

    string format(LogLevels logLevel, string logMessage, Json[string] logData = null) {
        return null;
    }
}
mixin(LogFormatterCalls!("Text"));
