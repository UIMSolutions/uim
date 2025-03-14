/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.containers.maps.values.string_;

@safe:
import std.algorithm : startsWith, endsWith;
import uim.core;
import uim.core.containers.maps.map;

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}


// #region set
/*   string[string] set(K, V:string, T)(string[string] items, string key, T value) if (!is(T == string) && !is(T == Json)) {
    return items.set(key, to!string(value));
  } */

/*   // #region string[string] set(..., bool value)
    string[string] set(string[string] items, string[] keys, bool value) {
      return set(items, keys, value ? "true" : "false");
    }
    unittest {
      string[string] testmap;
      assert(set(testmap, ["a", "b"], true)["a"] == "true");
      assert(set(testmap, ["c", "d"], false)["c"] == "false");
    }

    string[string] set(string[string] items, string key, bool value) {
      return set(items, key, value ? "true" : "false");
    }
    unittest {
      string[string] testmap;
      assert(set(testmap, "a", true)["a"] == "true");
      assert(set(testmap, "b", false)["b"] == "false");
    }
  // #endregion string[string] set(..., bool value)

  // #region string[string] set(..., int value)
    string[string] set(string[string] items, string[] keys, int value) {
      return set(items, keys, to!string(value));
    }
    unittest {
      string[string] testmap;
      assert(set(testmap, ["a", "b"], 0)["a"] == "0");
      assert(set(testmap, ["c", "d"], 1)["c"] == "1");
    }

    string[string] set(string[string] items, string key, int value) {
      return set(items, key, to!string(value));
    }
    unittest {
      string[string] testmap;
      assert(set(testmap, "a", 0)["a"] == "0");
      assert(set(testmap, "b", 1)["b"] == "1");
    }
  // #endregion string[string] set(..., int value)

  // #region string[string] set(..., long value)
    string[string] set(string[string] items, string[] keys, long value) {
      return set(items, keys, to!string(value));
    }
    unittest {
      string[string] testmap;
      assert(set(testmap, ["c", "d"], 1)["c"] == "1");
    }

    string[string] set(string[string] items, string key, long value) {
      return set(items, key, to!string(value));
    }
    unittest {
      string[string] testmap;
      assert(set(testmap, "a", 0)["a"] == "0");
      assert(set(testmap, "b", 1)["b"] == "1");
    }
 */  // #endregion string[string] set(..., long value)

  // #region string[string] set(..., double value)
/*     string[string] set(string[string] items, string[] keys, double value) {
      return set(items, keys, to!string(value));
    }
    unittest {
      string[string] testmap;
      assert(set(testmap, ["a", "b"], 0.1)["a"] == "0.1");
      assert(set(testmap, ["c", "d"], 1.1)["c"] == "1.1");
    }

    string[string] set(string[string] items, string key, double value) {
      return set(items, key, to!string(value));
    }
    unittest {
      string[string] testmap;
      assert(set(testmap, "a", 0.1)["a"] == "0.1");
      assert(set(testmap, "b", 1.1)["b"] == "1.1");
    }
  // #endregion string[string] set(..., double value)

  string[string] set(string[string] items, string key, Json value) {
    return set(items, key, value.toString);
  }

  string[string] set(string[string] items, string[] keys, string value) {
    keys.each!(key => items = items.set(key, value));
    return items;
  }

  string[string] set(string[string] items, string key, string value) {
    items[key] = value;
    return items;
  }
 */
  // #region string[string] set(..., string value)
/*   string[string] set(string[string] items, string[] keys, string value) {
    keys.each!(key => set(items, key, value));
    return items;
  }
 */  
   T[string] set(T:string)(T[string] items, string key, T value) {
    items[key] = value;
    return items;
  }

  unittest {
    string[string] testmap;
    assert(set(testmap, "a", "A")["a"] == "A");
    assert(set(testmap, "a", "A").set("b", "B")["b"] == "B");

  }
// #endregion set