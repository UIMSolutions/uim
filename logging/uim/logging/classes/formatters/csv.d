module uim.logging.formatters.csv;

import uim.logging;

@safe:
class DCsvLogFormatter : DLogFormatter {
  mixin(LogFormatterThis!("Csv"));

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

mixin(LogFormatterCalls!("Csv"));
