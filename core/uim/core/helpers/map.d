module uim.core.helpers.map;

import uim.core;

@safe:

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class MapHelper {
  static V[K] create(K, V)() {
    V[K] result; 
    return result;
  }

  unittest {
    auto items = MapHelper.create!(string, string)();
    assert(items.length == 0);
  }

  static V[K] clear(K, V)(ref V[K] items) {
    return V[K]();
  }

  unittest {
/*     auto items = MapHelper.create!(string, string)();
    items["a"] = "1";
    items["b"] = "2";
    // assert(MapHelper.clear(items).length == 0); */
  }

  static V[K] clone(K, V)(ref V[K] items) {
    return items.dup;
  }

  unittest {
    auto items = MapHelper.create!(string, string)();
    items["a"] = "1";
    items["b"] = "2";
    // assert(MapHelper.clone(items) == items);
  }

  static V[K] compact(K, V)(ref V[K] items) {
    // return items.filter!(value => value != null);
    return items;
  }

  unittest {
    auto items = MapHelper.create!(string, string)();
    items["a"] = "1";
    items["b"] = null;
    // // assert(MapHelper.compact(items) == ["a": "1"]);
  }

  static ref set(K, V)(ref V[K] items, K key, V value) {
    auto results = items.dup;
    results[key] = value;
    return results;
  }

  unittest {
    auto items = MapHelper.create!(string, string)();
    items["a"] = "1";
    items["b"] = "2";
    // assert(MapHelper.set(items, "b", "3") == ["a": "1", "b": "3"]);
  }

  static V[K] diff(K, V)(ref V[K] items, V[K] otherItems) {
    auto keys = items.keys.filter!(key => !(key in otherItems)).array;
    V[K] results;
    foreach (key; keys) {
      results[key] = items[key];
    }
    return results;
  }

  unittest {
    auto items = MapHelper.create!(string, string)();
    auto otherItems = MapHelper.create!(string, string)();
    items["a"] = "1";
    items["b"] = "2";
    otherItems["b"] = "2";
    otherItems["c"] = "3";
    // assert(MapHelper.diff(items, otherItems) == ["a": "1"]);
  }

  static V[K] intersect(K, V)(ref V[K] items, V[K] otherItems) {
    auto keys = items.keys.filter!(key => key in otherItems).array;

    V[K] results;
    foreach (key; keys) {
      results[key] = items[key];
    }
    return results;
  }

  unittest {
    auto items = MapHelper.create!(string, string)();
    auto otherItems = MapHelper.create!(string, string)();
    items["a"] = "1";
    items["b"] = "2";
    otherItems["b"] = "2";
    otherItems["c"] = "3";
    // assert(MapHelper.intersect(items, otherItems) == ["b": "2"]);
  }

  static bool isEmpty(K, V)(ref V[K] items) {
    return (items.length == 0);
  }

  unittest {
    auto items = MapHelper.create!(string, string)();
    // assert(items.isEmpty);

    items["a"] = "1";
    // assert(!items.isEmpty);
  }

  static ref merge(K, V)(ref V[K] items, V[K] otherItems) {
    V[K] results = items.dup;
    foreach (key, value; otherItems) {
      results[key] = value;
    }
    return results;
  }

  unittest {
    auto items = MapHelper.create!(string, string)();
    auto otherItems = MapHelper.create!(string, string)();
    items["a"] = "1";
    items["b"] = "2";
    otherItems["b"] = "2";
    otherItems["c"] = "3";
    // assert(MapHelper.merge(items, otherItems) == ["a": "1", "b": "2", "c": "3"]);
  }

  static V[K] remove(K, V)(ref V[K] items, K[] keys) {
    V[K] results = items.dup;
    keys.each!(key => results.remove(key));
    return results;
  }

  unittest {
    auto items = MapHelper.create!(string, string)();
    items["a"] = "1";
    items["b"] = "2";
    items["c"] = "3";
    // assert(MapHelper.remove(items, ["b", "c"]) == ["a": "1"]);
  }

  static V[K] remove(K, V)(ref V[K] items, K key) {
    V[K] results = items.dup;
    results.remove(key);
    return results;
  }

  unittest {
    auto items = MapHelper.create!(string, string)();
    items["a"] = "1";
    items["b"] = "2";
    // assert(MapHelper.remove(items, "b") == ["a": "1"]);
  }

  static V[K] reverse(K, V)(ref V[K] items) {
    V[K] results;
    foreach (key, value; items) {
      results[value] = key;
    }
    return results;
  }

  unittest {
    auto items = MapHelper.create!(string, string)();
    items["a"] = "1";
    items["b"] = "2";
    // assert(MapHelper.reverse(items) == ["1": "a", "2": "b"]);
  }

  static K[] sortedKeys(K, V)(ref V[K] items, SortDir dir = SortDir.ASC) {
    auto keys = items.keys;
/*     switch (dir) {
    case SortDir.ASC:
      return keys.sort!("a < b").array;
    case SortDir.DESC:
      return keys.sort!("a > b").array;
    default:
 */      return keys;
    // }
  }

  unittest {
    auto items = MapHelper.create!(string, string)();
    items["b"] = "2";
    items["a"] = "1";
/*     // assert(MapHelper.sortedKeys(items, SortDir.ASC) == ["a", "b"]);
    // assert(MapHelper.sortedKeys(items, SortDir.DESC) == ["b", "a"]); */
  }

  static V[] sortedValues(K, V)(ref V[K] items) {
    // return sort!(items.values, "a > b").array;
    return items.values;
  }

  unittest {
/*     auto items = MapHelper.create!(string, string)();
    items["b"] = "2";
    items["a"] = "1";
    // assert(MapHelper.sortedValues(items) == ["1", "2"]); */
  }

  static string toString(K, V)(ref V[K] items) {
    return "%s".format(items);
  }

  unittest {
    auto items = MapHelper.create!(string, string)();
    items["a"] = "1";
    items["b"] = "2";
    // assert(MapHelper.toString(items) == `["a": "1", "b": "2"]`);
  }

  static ref update(K, V)(ref V[K] items, V[K] updates) {
    V[K] results = items.dup;
    updates.keys
      .filter!(key => key in items)
      .each!(key => results[k] = updates[key]);
    return results;
  }

  unittest {
/*     auto items = MapHelper.create!(string, string)();
    auto updates = MapHelper.create!(string, string)();
    items["a"] = "1";
    items["b"] = "2";
    updates["b"] = "3";
    updates["c"] = "4";
    // assert(MapHelper.update(items, updates) == ["a": "1", "b": "3"]); */
  }

  static ref update(K, V)(ref V[K] items, K[] keys, V value) {
    V[K] results = items.dup;
    keys
      .filter!(key => key in items)
      .each!(key => results[k] = value);
    return results;
  }

  unittest {
/*     auto items = MapHelper.create!(string, string)();
    items["a"] = "1";
    items["b"] = "2";
    // assert(MapHelper.update(items, ["a", "b"], "3") == ["a": "3", "b": "3"]);

    items = MapHelper.create!(string, string)();
    items["a"] = "1";
    items["b"] = "2";
    // assert(MapHelper.update(items, ["a", "b", "c"], "3") == ["a": "3", "b": "3"]); */
  }

  static ref update(K, V)(ref V[K] items, K key, V value) {
    V[K] results = items.dup;
    if (key in items) {
      results[key] = value;
    }
    return results;
  }

  unittest {
    auto items = MapHelper.create!(string, string)();
    items["a"] = "1";
    items["b"] = "2";
    // assert(MapHelper.update(items, "b", "3") == ["a": "1", "b": "3"]);

    items = MapHelper.create!(string, string)();
    items["a"] = "1";
    items["b"] = "2";
    // assert(MapHelper.update(items, "b", "3") == ["a": "1", "b": "3"]);
  }
}

unittest {
  auto map = MapHelper.create!(string, string)();
}
