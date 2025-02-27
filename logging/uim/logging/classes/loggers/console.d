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
          .set("includeTags", true)) */;
    // `dateFormat` UIM date() format.

    return true;
  }
}
mixin(LoggerCalls!("Console"));

unittest {
    auto logger = new DConsoleLogger;
    assert(testLogger(logger));
}
