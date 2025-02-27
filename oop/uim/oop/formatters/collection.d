/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.formatters.collection;

import uim.oop;
@safe:

version (test_uim_oop) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DFormatterCollection : DCollection!DFormatter {   
}
auto FormatterCollection() { return new DFormatterCollection; } 

unittest {
  assert(FormatterCollection);

  auto collection = FormatterCollection;
}