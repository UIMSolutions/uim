module uim.logging.classes.formatters.html;

import uim.logging;

@safe:

class DHtmlLogFormatter : DLogFormatter {
  mixin(LogFormatterThis!("Html"));

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

mixin(LogFormatterCalls!("Html"));