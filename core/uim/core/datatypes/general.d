/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.datatypes.general;

import uim.core;

@safe:

unittest {
  writeln("-----  ", __MODULE__, "\t  -----");
}

size_t indexIn(T)(T value, T[] values) {
  foreach (i, ref v; values)
    if (v == value)
      return i;
  return -1;
}

unittest {
  assert(2.indexIn([1, 2, 3, 4]) == 1);
  assert(20.indexIn([1, 2, 3, 4]) == -1);
  assert((2.1).indexIn([1.5, 2.1, 3.3, 4.6]) == 1);
  assert((20.1).indexIn([1.5, 2.1, 3.3, 4.6]) == -1);
}

bool isIn(T)(T value, T[] values) {
  foreach (i, ref v; values)
    if (v == value) {
      return true;
    }
  return false;
}

unittest {
  assert(2.isIn([1, 2, 3, 4]));
  assert(!20.isIn([1, 2, 3, 4]));
  assert((2.1).isIn([1.5, 2.1, 3.3, 4.6]));
  assert(!(20.1).isIn([1.5, 2.1, 3.3, 4.6]));
}

size_t[] indexIn(T)(T[] checkValues, T[] values) {
  size_t[] results;
  foreach (ref v; checkValues)
    results ~= indexIn(v, values);
  return results;
}

unittest {
  assert([2, 3].indexIn([1, 2, 3, 4]) == [1, 2]);
  assert([20].indexIn([1, 2, 3, 4]) == [-1]);
}

size_t[] positionsIn(T)(T value, T[] values) {
  size_t[] results;
  foreach (i, ref v; values)
    if (v == value)
      results ~= i;
  return results;
}

unittest {
  assert(2.positionsIn([1, 2, 3, 2]) == [1, 3]);
  assert(20.positionsIn([1, 2, 3, 4]) is null);
  assert((2.1).positionsIn([1.5, 2.1, 3.3, 2.1]) == [1, 3]);
  assert((20.1).positionsIn([1.5, 2.1, 3.3, 4.6]) is null);
}

/// Copies rightValues to leftValues   
V[K] copyFrom(V, K)(V[K] leftValues, V[K] rightValues) { // right will overright left
  V[K] results = leftValues.dup;
  rightValues.byKeyValue
    .each!(kv => results[kv.key] = kv.value);

  return results;
}

///
unittest {
  assert(["a": "b"].copyFrom(["c": "d"]) == ["a": "b", "c": "d"]);
}

/// Concat rightValues to leftValues   
V[K] concatPrefixInValues(V, K)(V[K] leftValues, V preValue) { // right will overright left
  V[K] results;
  foreach (k, v; leftValues)
    results[k] = preValue ~ v;
  return results;
}

unittest {
  assert(["a": "b"].concatPrefixInValues("abc") == ["a": "abcb"]);
  assert(["a": [1, 2, 3]].concatPrefixInValues([0]) == ["a": [0, 1, 2, 3]]);
}

/// Concat rightValues to leftValues   
V[K] concatPostfixInValues(V, K)(V[K] leftValues, V postValue) { // right will overright left
  V[K] results;
  leftValues.byKeyValue
    .each!(kv => results[kv.key] = kv.value ~ postValue);
  return results;
}
///
unittest {
  assert(["a": "b"].concatPostfixInValues("abc") == ["a": "babc"]);
  assert(["a": [1, 2, 3]].concatPostfixInValues([4]) == ["a": [1, 2, 3, 4]]);
}

/// Concat rightValues to leftValues   
V[string] concatPrefixInKeys(V)(V[string] leftValues, string preValue) { // right will overright left
  V[string] results;
  leftValues.byKeyValue
    .each!(kv => results[preValue ~ kv.key] = kv.value);

  return results;
}

unittest {
  assert(["a": "b"].concatPrefixInKeys("abc") == ["abca": "b"]);
}

/// Concat rightValues to leftValues   
V[K] concatPostfixInKeys(V, K)(V[K] leftValues, V postValue) { // right will overright left
  V[K] results;
  foreach (k, v; leftValues)
    results[k ~ postValue] = v;
  return results;
}

unittest {
  assert(["a": "b"].concatPostfixInKeys("abc") == ["aabc": "b"]);
}

// #region toogle
bool toggle(bool value) {
  return !value;
}

T toggle(T)(T value, T value0, T value1) {
  return (value == value0)
    ? value1 : ((value == value1)
        ? value0 : value);
}

unittest {
  assert(false.toggle == true);
  assert(true.toggle == false);

  assert(1.toggle(1, 2) == 2);
  assert(2.toggle(1, 2) == 1);
  assert(3.toggle(1, 2) == 3);

  assert("Yes".toggle("Yes", "No") == "No");
  assert("No".toggle("Yes", "No") == "Yes");
  assert("Bla".toggle("Yes", "No") == "Bla");
}
// #endregion toogle
