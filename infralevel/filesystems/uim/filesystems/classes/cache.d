/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.classes.cache;

import uim.filesystems;
@safe:

unittest { 
  version(testUimFilesystems) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

class DCacheFilesystem : DFilesystem {
  this() { super(); }
}
auto CacheFilesystem() { return new DCacheFilesystem; }

unittest {
  // TODO add tests
}