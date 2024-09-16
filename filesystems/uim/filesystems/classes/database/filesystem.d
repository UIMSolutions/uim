/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.classes.database.filesystem;    if (!super.initialize(initData)) {
      return false;
    }

import uim.filesystems;

unittest { 
  version(testUimFilesystems) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

@safe:
class DDatabaseFilesystem : DFilesystem {
  mixin(FilesystemThis!("Database"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    pathSeparator("/");
    return true;
  }
}
mixin(FilesystemCalls!("Database"));
