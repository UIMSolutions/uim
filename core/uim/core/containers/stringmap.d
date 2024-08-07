/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (UIManufaktur)										                         * 
***********************************************************************************************************************/
module uim.core.containers.stringmap;

@safe:
import std.algorithm : startsWith, endsWith;
import uim.core;

// #region set
T[string] set(T)(ref T[string] items, string key, T value) {
  items[key] = value;
  return items;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ;
}

unittest {
  int[string] testmap = ["one": 1, "two": 2, "three": 3];
  assert(testmap.set("one", 2)["one"] == 2);
}
// #endregion set

// #region update
T[string] update(T)(ref T[string] items, string key, T value) {
  return items.hasKey(key)
    ? items.set(key, value)
    : items;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ;
}

unittest {
  int[string] testmap = ["one": 1, "two": 2, "three": 3];
  assert(testmap.update("one", 2)["one"] == 2);
}
// #endregion update

// #region merge
T[string] merge(T)(ref T[string] items, string key, T value) {
  return !items.hasKey(key)
    ? items.set(key, value)
    : items;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ;
}

unittest {
  int[string] testmap = ["one": 1, "two": 2, "three": 3];
  assert(testmap.merge("five", 5)["five"] == 5);
}
// #endregion merge
