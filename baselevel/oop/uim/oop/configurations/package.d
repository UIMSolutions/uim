/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.configurations;

version (test_uim_oop) {
  import std.stdio;
  
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

public { // Packages
    import uim.oop.configurations.engines;
}

public { // Modules
    // import uim.oop.configurations.config;
    import uim.oop.configurations.configuration;
    // import uim.oop.configurations.file;
    // import uim.oop.configurations.ini;
    import uim.oop.configurations.interfaces;
    import uim.oop.configurations.memory;
    import uim.oop.configurations.registry;
    // import uim.oop.configurations.xml;
    // import uim.oop.configurations.yaml;
    
    // import uim.oop.configurations.tests;
}