/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.interfaces.configurable;

mixin(Version!"test_uim_oop");

import uim.oop;
@safe:

import uim.oop;
@safe:

interface IConfigurable {
  // Gets configuration
  IConfiguration configuration();
  // Sets configuration
  void configuration(IConfiguration newConfiguration);

  /* final void setConfiguration(string key, Json value) {
    configuration.setEntry(key, value);
  } */

  /* final Json getConfiguration(string key) {
    return configuration.getEntry(key);
  } */
}
