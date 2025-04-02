/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.containers.maps.json;

mixin(Version!"test_uim_oop");

import uim.oop;
@safe:

class DJsonMap : DMap!(string, Json)  {
  this() {}
}
auto JsonMap() { return new DJsonMap; }

unittest {
  auto map = JsonMap;

  map["key1"] = Json("value1");
  map["key2"] = Json("value2");
  assert(map.length == 2);
/*   assert(map["key1"].toString == "value1");
  assert(map["key2"].toString == "value2");
 */
  map.removeKeys(["key1"]);
  assert(map.length == 1);
/*   assert(!map.containsKey("key1"));
  assert(map.containsKey("key2")); */
}