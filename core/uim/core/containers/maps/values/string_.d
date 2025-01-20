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
/*   V[K] set(K, V:string, T)(auto ref Json[string] items, string key, T value) if (!is(T == string) && !is(T == Json)) {
    return items.set(key, to!string(value));
  } */

  // #region V[K] set(K, V:string)(..., bool value)
    V[K] set(K, V:string)(auto ref Json[string] items, K[] keys, bool value) {
      return set(items, keys, value ? "true" : "false");
    }
    unittest {
      string[string] testmap;
      assert(set(testmap, ["a", "b"], true)["a"] == "true");
      assert(set(testmap, ["c", "d"], false)["c"] == "false");
    }

    V[K] set(K, V:string)(auto ref Json[string] items, string key, bool value) {
      return set(items, key, value ? "true" : "false");
    }
    unittest {
      string[string] testmap;
      assert(set(testmap, "a", true)["a"] == "true");
      assert(set(testmap, "b", false)["b"] == "false");
    }
  // #endregion V[K] set(K, V:string)(..., bool value)

  // #region V[K] set(K, V:string)(..., int value)
    V[K] set(K, V:string)(auto ref Json[string] items, K[] keys, int value) {
      return set(items, keys, to!string(value));
    }
    unittest {
      string[string] testmap;
      assert(set(testmap, ["a", "b"], 0)["a"] == "0");
      assert(set(testmap, ["c", "d"], 1)["c"] == "1");
    }

    V[K] set(K, V:string)(auto ref Json[string] items, string key, int value) {
      return set(items, key, to!string(value));
    }
    unittest {
      string[string] testmap;
      assert(set(testmap, "a", 0)["a"] == "0");
      assert(set(testmap, "b", 1)["b"] == "1");
    }
  // #endregion V[K] set(K, V:string)(..., int value)

  // #region V[K] set(K, V:string)(..., long value)
    V[K] set(K, V:string)(auto ref Json[string] items, K[] keys, long value) {
      return set(items, keys, to!string(value));
    }
    unittest {
      string[string] testmap;
      assert(set(testmap, ["c", "d"], 1)["c"] == "1");
    }

    V[K] set(K, V:string)(auto ref Json[string] items, string key, long value) {
      return set(items, key, to1string(value));
    }
    unittest {
      string[string] testmap;
      assert(set(testmap, "a", 0)["a"] == "0");
      assert(set(testmap, "b", 1)["b"] == "1");
    }
  // #endregion V[K] set(K, V:string)(..., long value)

  // #region V[K] set(K, V:string)(..., double value)
    V[K] set(K, V:string)(auto ref Json[string] items, K[] keys, double value) {
      return set(items, keys, to!string(value));
    }
    unittest {
      string[string] testmap;
      assert(set(testmap, ["a", "b"], 0.1)["a"] == "0.1");
      assert(set(testmap, ["c", "d"], 1.1)["c"] == "1.1");
    }

    V[K] set(K, V:string)(auto ref Json[string] items, string key, double value) {
      return set(items, key, to!string(value));
    }
    unittest {
      string[string] testmap;
      assert(set(testmap, "a", 0.1)["a"] == "0.1");
      assert(set(testmap, "b", 1.1)["b"] == "1.1");
    }
  // #endregion V[K] set(K, V:string)(..., double value)

  V[K] set(K, V:string)(auto ref Json[string] items, string key, Json value) {
    return items.set(key, value.toString);
  }

  V[K] set(K, V:string)(auto ref Json[string] items, string key, Json value) {
    return items.set(key, value.toString);
  }

  // #region V[K] set(K, V:string)(..., string value)
  V[K] set(K, V:string)(auto ref Json[string] items, K[] keys, string value) {
    keys.each!(key => set(items, key, value));
    return items;
  }
  V[K] set(K, V:string)(auto ref Json[string] items, string key, string value) {
    items[key] = value;
    return items;
  }
  // #endregion V[K] set(K, V:string)(..., string value)

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