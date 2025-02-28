module uim.logging.classes.loggers.console;

import uim.logging;

@safe:

version (test_uim_logging) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// Console logging. Writes logs to console output.
class DConsoleLogger : DLogger {
  mixin(LoggerThis!("Console"));

  override bool initialize(Json[string] initvalue = null) {
    if (!super.initialize(initvalue)) {
      return false;
    }

    configuration
      .setDefault("stream", "d://stderr") // `stream` the path to save logs on.
      .setDefault("levels", Json(null)) // `levels` string or array, levels the engine is interested in
      .setDefault("scopes", Json.emptyArray) // `scopes` string or array, scopes the engine is interested in
      .setDefault("outputAs", Json(null)) // `outputAs` integer or ConsoleOutput.[RAW|PLAIN|COLOR]
      /* .setDefault("formatter", createMap!(string, Json)
          .set("classname", StandardLogFormatter.className)
          .set("includeTags", true)) */
      ;
    // `dateFormat` UIM date() format.

    /* if (cast(DConsoleOutput) configuration.get("stream")) {
      _output = configuration.get("stream");
    } else if (configuration.isString("stream")) {
      _output = new DConsoleOutput(configuration.get("stream"));
    } else {
      throw new DInvalidArgumentException("`stream` not a ConsoleOutput nor string");
    }
    if (configuration.hasKey("outputAs")) {
      _output.setOutputAs(configuration.get("outputAs"));
    } */

    return true;
  }

  // #region output
  // Output stream
  protected IOutput _output;
  IOutput output() {
    return _output;
  }

  ILogger output(IOutput newOutput) {
    _output = newOutput;
    return this;
  }

  override ILogger log(LogLevel logLevel, string logMessage, Json[string] logContext = null) {
    /* string resultMessage = this.interpolate(messageToLog, context);
    _output.write(this.formatter.format(logLevel, resultMessage, context)); */
    return this;
  }
}

mixin(LoggerCalls!("Console"));

unittest {
  auto logger = new DConsoleLogger;
  assert(testLogger(logger));
}
