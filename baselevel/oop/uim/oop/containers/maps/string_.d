/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.containers.maps.string_;

mixin(Version!"test_uim_oop");

import uim.oop;
@safe:

class DStringMap : DMap!(string, string) {
  this() {}
}
auto StringMap() { return new DStringMap; }

unittest {
    auto map = StringMap;
    
    map["key1"] = "value1";
    map["key2"] = "value2";
    assert(map.length == 2);
/*     assert(map["key1"] == "value1");
    assert(map["key2"] == "value2"); */
    
    map.removeKeys(["key1"]);
    assert(map.length == 1);
/*     assert(!map.containsKey("key1"));
    assert(map.containsKey("key2")); */
}