/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.helpers;

public {
  import uim.filesystems.helpers.entry;
  import uim.filesystems.helpers.filesystem;
  import uim.filesystems.helpers.file;
  import uim.filesystems.helpers.folder;
}

@safe:
string[] toPathItems(string aPath, string aSeparator = "/") {
  import std.array;
  import std.algorithm;
  import std.string;
  import uim.core;

  return aPath
    .split(aSeparator ? aSeparator : "/")
    .stripText
    .filter!(item => item.length > 0)
    .array;
}

unittest {
  assert(toPathItems("abc", "/") == ["abc"]);
  assert(toPathItems("a/b/c", "/") == ["a", "b", "c"]);
  assert(toPathItems("a/b/c", "\\") == ["a/b/c"]);
}
