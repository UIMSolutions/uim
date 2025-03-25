/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.classes.cache;

mixin(Version!"test_uim_filesystems");

import uim.filesystems;
@safe:

class DCacheFilesystem : DFilesystem {
  this() { super(); }
}
auto CacheFilesystem() { return new DCacheFilesystem; }

unittest {
  // TODO add tests
}