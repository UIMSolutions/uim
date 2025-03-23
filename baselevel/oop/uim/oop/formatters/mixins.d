/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.formatters.mixins;

version (test_uim_oop) {
  import std.stdio;

  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

import uim.oop;
@safe:

string formatterThis(string name = null) {
  string fullName = name ~ "Formatter";
  return objThis(fullName);
}

template FormatterThis(string name = null) {
  const char[] FormatterThis = formatterThis(name);
}

string formatterCalls(string name) {
  string fullName = name ~ "Formatter";
  return objCalls(fullName);
}

template FormatterCalls(string name) {
  const char[] FormatterCalls = formatterCalls(name);
}
