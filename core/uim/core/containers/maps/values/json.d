/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.containers.maps.values.json;

@safe:
import std.algorithm : startsWith, endsWith;
import uim.core;

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}


/* Json[string] setNull(Json[string] items, string[] path) {
  return set(items, path, Json(null));
}

Json[string] setNull(Json[string] items, string key) {
  return set(items, key, Json(null));
}

Json[string] setPath(T)(Json[string] items, string[] path, T value) {
  set(items, path, Json(value));
  return items;
}

Json[string] setPath(Json[string] items, string[] path, Json value) {
  if (path.length == 0) {
    return items;
  }

  if (path.length == 1) {
    return set(items, path[0], value);
  } */

  /*   Json json = Json.emptyObject;
  return set(items, path[0], json.set(path[1..$], value));                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ;
 */
/*   return null;
} */
