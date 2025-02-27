module uim.logging.classes.loggers.logger;

import uim.logging;
@safe:

version (test_uim_logging) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DLogger : UIMObject, ILogger {
  mixin(LoggerThis!());

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }
  }

    // Get the levels this logger is interested in.
  string[] levels() {
    return configuration.getStrings("levels");
  }

  // Get the scopes this logger is interested in.
  string[] scopes() {
    return configuration.getStrings("scopes");
  }

  ILogger log(LogLevel logLevel, string logMessage, Json[string] logContext = null) {
    return this;
  }
}