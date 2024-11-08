/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.helpers.entry;

import uim.filesystems;

unittest {
  version (testUimFilesystems) {
    debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
  }
}

@safe:

string debugInfo(IFilesystemEntry anEntry) {
  if (anEntry is null) {
    return "entry is missing (null).";
  }

  return `
-----------
Filesystem entry info:
\tName =\t%s
\tPath =\t%s
-----------`.format(anEntry.name, anEntry.path);
}
