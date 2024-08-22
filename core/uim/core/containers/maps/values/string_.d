/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (UIManufaktur)										                         * 
***********************************************************************************************************************/
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
    writeln("testmap => ", testmap.set("one", 2));

    Json x = Json.emptyObject;
    x["1"] = true;

    writeln("testmap => ", testmap.set("one", x));
    assert(set(testmap, "a", "A")["a"] == "A");
    assert(set(testmap, "a", "A").set("b", "B")["b"] == "B");
  }
// #endregion set