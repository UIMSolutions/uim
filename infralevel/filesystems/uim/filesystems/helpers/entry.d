/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.helpers.entry;

mixin(Version!"test_uim_filesystems");

import uim.filesystems;
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
