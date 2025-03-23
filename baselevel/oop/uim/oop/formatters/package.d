/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.formatters;

version (test_uim_oop) {
  import std.stdio;
  
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

public {
    import uim.oop.formatters.formatter;
}

public {
    import uim.oop.formatters.collection;
    import uim.oop.formatters.factory;
    import uim.oop.formatters.interfaces;
    import uim.oop.formatters.mixins;
    import uim.oop.formatters.registry;
}