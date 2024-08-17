/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (UIManufaktur)										                         * 
***********************************************************************************************************************/
module uim.core.containers.maps.keys.string_;

@safe:
import std.algorithm : startsWith, endsWith;
import uim.core;

/// Add prefix to key
V[K] addKeyPrefix(K : string, V)(V[K] items, string prefix) {
  items.byKeyValue
    .each!(item => items = items.addKeyPrefix(item.key, prefix));
  return items;
}

V[K] addKeyPrefix(K : string, V)(V[K] items, K key, string prefix) {
  return !items.hasKey(key) || prefix.isEmpty
    ? items : items.set(prefix ~ key).remove(key);
}

unittest {
  assert(["a": "1", "b": "2"].addKeyPrefix("b", "x").hasKey("xb"));
  assert(["a": "1", "b": "2"].addKeyPrefix("a", "x").hasKey("a"));
  assert(["a": "1", "b": "2"].addKeyPrefix("b", "x")["xb"] == "2");
  assert(["a": "1", "b": "2"].addKeyPrefix("a", "x")["a"] == "1");

  assert(["a": "1"].addKeyPrefix("x") == ["xa": "1"]);
  assert(["a": "1", "b": "2"].addKeyPrefix("x").hasKey("xb"));

}
