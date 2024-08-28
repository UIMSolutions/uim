module uim.logging.formatters.json;

import uim.logging;

@safe:
class DJsonLogFormatter : DLogFormatter {
  mixin(LogFormatterThis!("Json"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    configuration
      .setDefault("dateFormat", "DATE_ATOM")
      .setDefault("appendNewline", true);

    return true;
  }

  override string format(LogLevels logLevel, string logMessage, Json[string] logData = null) {
    Json[string] log = createMap!(string, Json)
      // .set("date", uim.core.datatypes.datetime.toString(nowDateTime, configuration.getString("dateFormat"))) 
      .set("level", to!string(logLevel))
      .set("message", logMessage);

    return log.toString ~ configuration.hasKey("appendNewline") ? "\n" : "";
  }
}
mixin(LogFormatterCalls!("Json"));
