/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.containers.maps.values.map;

@safe:
import uim.core;

unittest {
  writeln("-----  ", __MODULE__, "\t  -----");
}

// #region filterValues
V[K] filterValues(K, V)(V[K] items) {
  V[K] results;
  items.byKeyValue
    .filter!(item => !item.value.isNull)
    .each!(item => results[item.key] = item.value);

  return results;
}

V[K] filterValues(K, V)(V[K] items, bool delegate(string key, Json value) check) {
  V[K] results;
  () @trusted {
    items.byKeyValue
      .filter!(item => check(item.key, item.value))
      .each!(item => results[item.key] = item.value);
  }();
  return results;
}

unittest {
  auto testString = ["a": "1", "b": null, "c": "3"];
  assert(testString.filterValues().length == 2);
  writeln(testString.filterValues());

  auto testValues = ["a": 1, "b": 2, "c": 3];
  bool foo(string key, int value) {
    return value > 1;
  }

/*   assert(testValues.filterValues(&foo).length == 2); */
}
// #endregion filterValues

// #region removeByValues
V[K] removeByValues(K, V)(V[K] items, Json[] values...) {
  return removeByValues(items, values.dup);
}

V[K] removeByValues(K, V)(V[K] items, Json[] values) {
  values.each!(value => removeByValue(items, value));
  return items;
}

V[K] removeByValue(K, V)(V[K] items, Json value) {
  return null; // TODO
  /*   return hasValue(items, value)
    ? items.remove(keyByValue(items, value)) : items; */
}

unittest {
  assert(["a": "A", "b": "B", "c": "C"].length == 3);
  /* 
  assert(["a": "A", "b": "B", "c": "C"].removeByValue("A").length == 2);
  assert(["a": "A", "b": "B", "c": "C"].removeByValue("A")["c"] == "C");

  assert(["a": "A", "b": "B", "c": "C"].removeByValues("A").length == 2);
  assert(["a": "A", "b": "B", "c": "C"].removeByValues(["A", "B"]).length == 1);
  assert(["a": "A", "b": "B", "c": "C"].removeByValues("A", "B").length == 1);

  assert(["a": "A", "b": "B", "c": "C"].removeByValues("A")["c"] == "C");
  assert(["a": "A", "b": "B", "c": "C"].removeByValues(["A", "B"])["c"] == "C");
  assert(["a": "A", "b": "B", "c": "C"].removeByValues("A", "B")["c"] == "C"); */
}
// #endregion removeByValues
