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

    writeln("StandardLogFormatter.classname -> ", StandardLogFormatter.classname);
    configuration
      .setEntry("stream", "d://stderr") // `stream` the path to save logs on.
      .setEntry("levels", Json(null)) // `levels` string or array, levels the engine is interested in
      .setEntry("scopes", Json.emptyArray) // `scopes` string or array, scopes the engine is interested in
      .setEntry("outputAs", Json(null)) // `outputAs` integer or ConsoleOutput.[RAW|PLAIN|COLOR]
      /* .setEntry("formatter", createMap!(string, Json)
          .set("classname", StandardLogFormatter.className)
          .set("includeTags", true)) */
      ;
    // `dateFormat` UIM date() format.

    /* if (cast(DConsoleOutput) configuration.getEntry("stream")) {
      _output = configuration.getEntry("stream");
    } else if (configuration.isStringEntry("stream")) {
      _output = new DConsoleOutput(configuration.getEntry("stream"));
    } else {
      throw new DInvalidArgumentException("`stream` not a ConsoleOutput nor string");
    }
    if (configuration.hasEntry("outputAs")) {
      _output.setOutputAs(configuration.getEntry("outputAs"));
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

  override ILogger log(LogLevels logLevel, string logMessage, Json[string] logContext = null) {
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
