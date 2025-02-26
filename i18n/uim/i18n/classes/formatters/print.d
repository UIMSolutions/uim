/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.classes.formatters.print;

import uim.i18n;

@safe:

version (test_uim_i18n) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// A formatter that will interpolate variables and select the correct plural form when required
class DPrintFormatter : DI18NFormatter {
  // Returns a string with all passed variables interpolated into the original message. 
  override string format(string local, string message, string[] tokens) {
    tokens.each!((token) {
      if (message.contains("%s")) {
        auto pos = message.indexOf("%s");
        message = message[0 .. pos] ~ token ~ message[pos + "%s".length .. $];
      }
    });
    return message;
  }
}

unittest {
  auto formatter = new DPrintFormatter;
  assert(formatter.format("en", "message", ["A", "B"]) == "message");
  assert(formatter.format("en", "1:%s 2:%s", null) == "1:%s 2:%s");
  assert(formatter.format("en", "1:%s 2:%s", ["A", "B"]) == "1:A 2:B");
  assert(formatter.format("en", "1:%s 2:%s", ["A", "B", "C"]) == "1:A 2:B");
  assert(formatter.format("en", "1:%s 2:%s 3:%s", ["A", "B"]) == "1:A 2:B 3:%s");
}

static this() {

}