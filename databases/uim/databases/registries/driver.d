/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.databases.registries.driver;

import uim.databases;
@safe:

version (test_uim_databases) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// A registry object for database instances.
class DDriverRegistry : DObjectRegistry!DDriver {
}

auto DriverRegistration() {
    return DDriverRegistry.registration;
}