/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.interfaces.configurable;

version (test_uim_oop) {
  import std.stdio;

  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

import uim.oop;
@safe:

interface IConfigurable {
  // Gets configuration
  IConfiguration configuration();
  // Sets configuration
  void configuration(IConfiguration newConfiguration);

  final void setConfiguration(string key, Json value) {
    configuration.set(key, value);
  }

  final Json getConfiguration(string key) {
    return configuration.get(key);
  }
}
