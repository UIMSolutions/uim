/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (UIManufaktur)										                         * 
***********************************************************************************************************************/
module uim.core.containers.maps.values.json;

@safe:
import std.algorithm : startsWith, endsWith;
import uim.core;

// #region set
  V[K] set(K, V:Json, T)(V[K] items, K key, T value) if (!is(T == Json)) {
    return items.set(key, Json(value));
  }

  V[K] set(K, V:Json)(V[K] items, K key, Json value) {
    items[key] = value;
    return items;
  }

  unittest {
    Json[string] testmap;

    Json x = Json.emptyObject;
    x["1"] = true;

    assert(set(testmap, "a", "A")["a"] == "A");
    assert(set(testmap, "a", "A").set("b", "B")["b"] == "B");
  }
// #endregion set