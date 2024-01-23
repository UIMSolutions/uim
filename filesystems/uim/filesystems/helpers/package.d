/***********************************************************************************
*	Copyright: ©2015- 2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
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
  return aPath
    .split(aSeparator ? aSeparator : "/")
    .map!(item => strip(item))
    .filter!(item => item.length > 0)
    .array;
}

unittest {
  assert(toPathItems("abc", "/") == ["abc"]);
  assert(toPathItems("a/b/c", "/") == ["a", "b", "c"]);
  assert(toPathItems("a/b/c", "\\") == ["a/b/c"]);
}