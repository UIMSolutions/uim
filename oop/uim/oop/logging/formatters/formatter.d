module uim.oop.logging.formatters.formatter;

import uim.oop;
@safe:

// Base class for LogFormatters
class DLogFormatter : UIMObject, ILogFormatter {
    mixin(LogFormatterThis!(""));
/*    mixin TLocatorAware;
    mixin TLog; */

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

  // Formats message.
  abstract string format(LogLevels logLevel, string logMessage, Json[string] logData = null);
}
