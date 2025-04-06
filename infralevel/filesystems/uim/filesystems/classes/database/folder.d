/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.classes.database.folder;

mixin(Version!"test_uim_filesystems");

import uim.filesystems;
@safe:

class DDatabaseFolder : DFolder {
  mixin(FolderThis!("Database"));

  override Json[string] debugInfo(string[] showKeys = null, string[] hideKeys = null) {
    return super.debugInfo(showKeys, hideKeys);
  }
}
mixin(FolderCalls!("Database"));

unittest {
  assert(DatabaseFolder);
}