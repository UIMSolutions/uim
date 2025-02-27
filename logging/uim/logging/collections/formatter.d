/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.logging.collections.formatter;

import uim.logging;
@safe:

class DLogFormatterCollection : DCollection!DLogFormatter {   
}
auto LogFormatterCollection() { return new DLogFormatterCollection; }

unittest {
  assert(LogFormatterCollection);

  auto collection = LogFormatterCollection;
}