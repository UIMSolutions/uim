module uim.logging.classes.loggers.console;

import uim.logging;

@safe:

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
      .setDefault("formatter", createMap!(string, Json)
          .set("classname", StandardLogFormatter.classname)
          .set("includeTags", true));
      // `dateFormat` UIM date() format.

    return true;
  }
  /*
    // Output stream
    protected IConsoleOutput _output;

  this(Json[string] configData = null) {
    super(configData);

    configData = configuration;
    if (cast(DConsoleOutput) configuration.get("stream")) {
      _output = configuration.get("stream");
    } else if (configuration.isString("stream")) {
      _output = new DConsoleOutput(configuration.get("stream"));
    } else {
      throw new DInvalidArgumentException("`stream` not a ConsoleOutput nor string");
    }
    if (configuration.hasKey("outputAs")) {
      _output.setOutputAs(configuration.get("outputAs"));
    }
  }

  // : writing to console.
  void log(Json logLevel, string messageToLog, Json context = null) {
    string resultMessage = this.interpolate(messageToLog, context);
    _output.write(this.formatter.format(logLevel, resultMessage, context));
  } */
  override ILogger log(LogLevels logLevel, string logMessage, Json[string] logContext = null) {
    return this; 
  }

}
    mixin(LoggerCalls!("Console"));
