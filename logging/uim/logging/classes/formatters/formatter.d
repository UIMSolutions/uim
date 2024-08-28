module uim.logging.formatters.formatter;

import uim.logging;
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
    
        configuration
            .setDefault("dateFormat", "Y-m-d H:i:s")
            .setDefault("includeTags", false)
            .setDefault("includeDate", true);
		
        return true;
    }

  // Formats message.
  abstract string format(LogLevels logLevel, string logMessage, Json[string] logData = null);
}
