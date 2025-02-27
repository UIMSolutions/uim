/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.logging.classes.loggers.standard;

import uim.logging;
@safe:

version (test_uim_logging) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DStandardLogger : DLogger {
  mixin(LoggerThis!("Standard"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }
}
mixin(LoggerCalls!("Standard"));
