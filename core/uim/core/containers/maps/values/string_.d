/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.containers.maps.values.string_;

@safe:
import std.algorithm : startsWith, endsWith;
import uim.core;

unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}

// #region set
  V[K] set(K, V:string, T)(V[K] items, K key, T value) if (!is(T == string) && !is(T == Json)) {
    return items.set(key, to!string(value));
  }

  V[K] set(K, V:string)(V[K] items, K key, Json value) {
    return items.set(key, value.toString);
  }

  V[K] set(K, V:string)(V[K] items, K key, V value) {
    items[key] = value;
    return items;
  }

  unittest {
    string[string] testmap;
    // writeln("testmap => ", testmap.set("one", 2));

    Json x = Json.emptyObject;
    x["1"] = true;

    // writeln("testmap => ", testmap.set("one", x));
    assert(set(testmap, "a", "A")["a"] == "A");
    assert(set(testmap, "a", "A").set("b", "B")["b"] == "B");

  }
// #endregion set