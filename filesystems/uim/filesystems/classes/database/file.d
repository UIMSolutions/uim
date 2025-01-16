/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.classes.database.file;

import uim.filesystems;

unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}

@safe:
class DDatabaseFile : DFile {
  mixin(FileThis!("Database"));

  override Json[string] debugInfo(string[] showKeys = null, string[] hideKeys = null) {
    return super.debugInfo(showKeys, hideKeys);
  }
}
mixin(FileCalls!("Database"));