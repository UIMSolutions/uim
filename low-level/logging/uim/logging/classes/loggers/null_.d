/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.logging.classes.loggers.null_;

import uim.logging;

@safe:

version (test_uim_logging) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DNullLogger : DLogger {
  mixin(LoggerThis!("Null"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  override ILogger log(LogLevels logLevel, string logMessage, Json[string] logContext = null) {
    // TODO
    return this;
  }
}

mixin(LoggerCalls!("Null"));

unittest {
  auto logger = NullLogger;
  assert(testLogger(logger));
}