﻿/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (UIManufaktur)										                         * 
***********************************************************************************************************************/
module uim.core.containers.array_;

import uim.core;

@safe:

size_t size(T)(T[] anArray) {
  return anArray.length;
}

// #region count
size_t[T] countDuplicates(T)(in T[] baseArray...) {
  return countDuplicates(baseArray.dup);
}

version (test_uim_core) {
  unittest {
    assert(countDuplicates(1) == [1: 1uL]);
    assert(countDuplicates(1, 1) == [1: 2uL]);
    assert(countDuplicates(1, 2) == [1: 1U, 2: 1UL]);
  }
}

/// Counts the occourence of values in an array
size_t[T] countDuplicates(T)(in T[] someValues) {
  size_t[T] results;
  someValues
    .each!(value => results[value] = value in results ? results[value] + 1 : 1);

  return results;
}
///
unittest {
  assert(countDuplicates([1]) == [1: 1uL]);
  assert(countDuplicates([1, 1]) == [1: 2uL]);
  assert(countDuplicates([1, 2]) == [1: 1uL, 2: 1uL]);
}

size_t countDuplicate(T)(T[] someValues, T aValue) {
  size_t result;
  result = someValues.filter!(value => value == aValue).count;

  return result;
}
///
unittest {
  assert([1, 2, 3].countDuplicate(2) == 1);
  assert([1, 2, 3].countDuplicate(4) == 0);
  assert([1, 2, 2].countDuplicate(2) == 2);
}
// #endregion count

size_t firstPosition(T)(in T[] baseArray, in T value) {
  foreach (index, item; baseArray)
    if (item == value)
      return index;
  return -1;
}
///
unittest {
  assert(["1", "3", "5"].firstPosition("3") == 1);
}

/// Creates a associative array with all positions of a value in an array
auto positions(T)(in T[] baseArray...) {
  size_t[][T] results = positions(baseArray, null);
  return results;
}

///
unittest {
  assert(positions(1) == [1: [0UL]]);
  assert(positions(1, 1) == [1: [0UL, 1UL]]);
  assert(positions(1, 2) == [1: [0UL], 2: [1UL]]);
}

/// Creates a associative array with all positions of a value in an array
size_t[][T] positions(T)(in T[] baseArray, in T[] validValues = null) {
  size_t[][T] results;
  auto checkValues = (validValues ? baseArray.filters(validValues) : baseArray);
  foreach (pos, v; checkValues) {
    results[v] = v in results
      ? results[v] ~ pos : [pos];
  }
  return results;
}

unittest {
  assert(positions([1]) == [1: [0UL]]);
  assert(positions([1, 1]) == [1: [0UL, 1UL]]);
  assert(positions([1, 2]) == [1: [0UL], 2: [1UL]]);
  assert(positions([1, 2], [1]) == [1: [0UL]]);
}

/// adding items into array
T[] add(T)(in T[] baseArray, in T[] newItems...) {
  return add(baseArray, newItems);
}

version (test_uim_core) {
  unittest {
    assert([1, 2, 3].add(4) == [1, 2, 3, 4]);
    assert([1, 2, 3].add(4, 5) == [1, 2, 3, 4, 5]);
    assert([1.0, 2.0, 3.0].add(4.0, 5.0) == [1.0, 2.0, 3.0, 4.0, 5.0]);
    assert(["1", "2", "3"].add("4", "5") == ["1", "2", "3", "4", "5"]);
  }
}

/// Adds items into array - same like "baseArray~newItems"
T[] add(T)(in T[] baseArray, in T[] newItems) {
  T[] results = baseArray.dup;
  results ~= newItems;
  return results;
}

version (test_uim_core) {
  unittest {
    assert([1, 2, 3].add([4, 5]) == [1, 2, 3, 4, 5]);
    assert([1.0, 2.0, 3.0].add([4.0, 5.0]) == [1.0, 2.0, 3.0, 4.0, 5.0]);
    assert(["1", "2", "3"].add(["4", "5"]) == ["1", "2", "3", "4", "5"]);
  }
}

/// Changes positions
void change(T)(ref T left, ref T right) {
  T buffer = left;
  left = right;
  right = buffer;
}
/// Changs positions of elements in array
T[] change(T)(T[] values, size_t firstPosition, size_t secondPosition) {
  if ((firstPosition >= values.length) || (secondPosition >= values.length) || (
      firstPosition == secondPosition))
    return values;

  T[] results = values.dup;
  T buffer = results[firstPosition];
  results[firstPosition] = results[secondPosition];
  results[secondPosition] = buffer;
  return results;
}

version (test_uim_core) {
  unittest {
    assert(change([1, 2, 3, 4], 1, 2) == [1, 3, 2, 4]);
    assert(change(["a", "b", "c", "d"], 3, 2) == ["a", "b", "d", "c"]);
    assert(change(["a", "b", "c", "d"], 1, 1) == ["a", "b", "c", "d"]);
    assert(change(["a", "b", "c", "d"], 1, 9) == ["a", "b", "c", "d"]);
  }
}

/// Removes
T[] sub(T)(T[] lhs, T rhs, bool multiple = false) {
  auto result = lhs.dup;
  if (multiple) {
    while (rhs.isIn(result))
      result = result.sub(rhs);
  } else
    foreach (i, value; result) {
      if (value == rhs) {
        result = result.remove(i);
        break;
      }
    }
  return result;
}

version (test_uim_core) {
  unittest {
    assert([1, 2, 3].sub(2) == [1, 3]);
    assert([1, 2, 3, 2].sub(2, true) == [1, 3]);
  }
}

// sub(T)(T[] lhs, T[] rhs, bool multiple = false)
T[] sub(T)(T[] lhs, T[] rhs, bool multiple = false) {
  auto result = lhs.dup;
  rhs.each!(value => result = result.sub(value, multiple));
  return result;
}
/// 
unittest {
  assert([1, 2, 3].sub([2]) == [1, 3]);
  assert([1, 2, 3, 2].sub([2], true) == [
      1, 3
    ]);
  assert([1, 2, 3, 2].sub([2, 3], true) == [1]);
  assert([1, 2, 3, 2, 3].sub([
        2, 3
      ], true) == [1]);
}

// filters(T)(T[] lhs, T[] rhs, bool multiple = false)
T[] filters(T)(T[] baseArray, T[] filterValues...) {
  return filters(baseArray, filterValues);
}

version (test_uim_core) {
  unittest {
    assert([1, 2, 3].filters(2) == [2]);
    assert([1, 2, 3].filters() is null);
    assert([
        1, 2, 3
      ].filters(1, 2) == [1, 2]);
  }
}

T[] filters(T)(T[] baseArray, T[] filterValues) {
  T[] results = baseArray.filter!(item => filterValues.has(item)).array;
  return results;
}

version (test_uim_core) {
  unittest {
    assert([1, 2, 3].filters([2]) == [2]);
    assert([1, 2, 3].filters([]) == [
      ]);
  }
}

OUT[] castTo(OUT, IN)(IN[] values) {
  OUT[] results;
  results.length = values.length;
  foreach (i, value; value) {
    result[i] = to!OUT(value);
  }

  return results;
}

unittest {
  auto values = [1, 2, 3, 4];
  change(values[2], values[3]);
  assert(values == [
      1, 2, 4, 3
    ]);
  assert([1, 2, 3, 4].change(1, 3) == [1, 4, 3, 2]);
}

// #region Searching

bool exist(T)(in T[] values, in T[] checkValues...) {
  return hasAllValues(values, checkValues);
}

bool has(T)(in T[] source, in T[] values...) {
  return hasAllValues(source, values.dup);
}

bool has(T)(in T[] source, in T[] values) {
  return hasAllValues(source, values);
}

// #region hasAllValues & hasValue
bool hasAllValues(T)(in T[] source, in T[] values...) {
  return hasAllValues(source, values.dup);
}

bool hasAllValues(T)(in T[] source, in T[] values) {
  return source.isEmpty || values.isEmpty
    ? false : values.all!(value => hasValue(source, value));
}
///
unittest {
  assert([1, 2, 3, 4].hasAllValues(1));
  assert(![
      1, 2, 3, 4
    ].hasAllValues(5));
  assert([1, 2, 3, 4].hasAllValues(1, 2));
  assert(![1, 2, 3, 4].hasAllValues(5, 1));
  assert([
      1, 2, 3, 4
    ].hasAllValues([1]));
  assert(![1, 2, 3, 4].hasAllValues([
        5
      ]));
  assert([1, 2, 3, 4].hasAllValues([1, 2]));
  assert(![
      1, 2, 3, 4
    ].hasAllValues([5, 1]));
}

// similar to has
bool hasAnyValues(T)(in T[] source, in T[] values...) {
  return hasAnyValues(source, values.dup);
}

bool hasAnyValues(T)(in T[] source, in T[] values) {
  if (source.isEmpty || values.isEmpty) {
    return false;
  }

  return values.any!(value => source.hasValue(value));
}
///
unittest {
  assert([1, 2, 3, 4].hasAnyValues(1));
  assert(![
      1, 2, 3, 4
    ].hasAnyValues(5));
  assert([1, 2, 3, 4].hasAnyValues(1, 2, 6));
  assert(![1, 2, 3, 4].hasAnyValues(5, 6));
  assert([
      1, 2, 3, 4
    ].hasAnyValues([1]));
  assert(![
      1, 2, 3, 4
    ].hasAnyValues([5]));
  assert([
      1, 2, 3, 4
    ].hasAnyValues([1, 2]));
  assert([
      1, 2, 3, 4
    ].hasAnyValues([1, 2, 5]));
  assert(![
      1, 2, 3, 4
    ].hasAnyValues([5, 6]));
}

bool hasValue(T)(in T[] source, in T aValue) {
  foreach (myValue; source) {
    if (myValue == aValue) {
      return true;
    }
  }
  return false;
}
// #endregion hasAllValues & hasValue

size_t index(T)(T[] values, T value) {
  foreach (count, key; values) {
    if (key == value) {
      return count;
    }
  }

  return -1;
}
/// 
unittest {
  assert([1, 2, 3, 4].index(1) == 0);
  assert([1, 2, 3, 4].index(0) == -1);
}

bool isIn(T)(T value, T[] values) {
  return values.any!(v => v == value);
}
/// 
unittest {
  assert(1.isIn([1, 2, 3, 4]));
  assert(!10.isIn([1, 2, 3, 4]));
}

size_t[] indexes(T)(T[] values, T value) {
  size_t[] results;
  foreach (count, key; values)
    if (key == value)
      results ~= count;
  return results;
}
///
unittest {
  assert([1, 2, 3, 4].indexes(1) == [0]);
  assert([1, 2, 3, 4].indexes(0) == null);
  assert([1, 2, 3, 4, 1].indexes(1) == [
      0, 4
    ]);
}

size_t[][T] indexes(T)(T[] values, T[] keys) {
  size_t[][T] results;
  foreach (key; keys)
    results[key] = indexes(values, key);
  return results;
}

version (test_uim_core) {
  unittest {
    assert([1, 2, 3, 4].indexes(
        [1]) == [
        1: [0UL]
      ]);

    assert([
        1, 2, 3, 4, 1
      ].indexes([1]) == [
        1: [0UL, 4UL]
      ]);
  }
}
// #endregion Searching

T shiftFirst(T)(ref T[] values) {
  // IN Check
  if (values.isEmpty) {
    return null;
  }

  auto value = values[0];

  values = values.length > 1
    ? values[1 .. $] : null;

  return value;
}
///
unittest {
  string[] anArray = [
    "x", "y",
    "z"
  ];
  assert(
    anArray.shiftFirst == "x");
  assert(anArray == [
      "y",
      "z"
    ]);
}



T[] ifNull(T)(T[] values, T[] defaultValues = null) {
  return values.isNull ? defaultValues : values;
}

unittest {
  // TODO create tests
}

T[] ifEmpty(T)(T[] values, T[] defaultValues = null) {
  return values.isEmpty
    ? defaultValues : values;
}

unittest {
  // TODO create test
}

// #region isNull
bool isNull(T)(T[] values) {
  return values is null;
}

unittest {
  string[] values;
  assert(values.isNull);

  values ~= "x";
  assert(!values.isNull);
}
// #endregion isNull

// #region isEmpty
bool isEmpty(T)(T[] values) {
  return values.length == 0;
}

unittest {
  int[] x;
  assert(x.isEmpty);
  assert(![1, 2, 3, 4].isEmpty);
  assert([].isEmpty);
}// #endregion isEmpty


// #region remove
T[] removeFirst(T)(T[] values) {
  if (values.isEmpty) { return values; }
  if (values.length == 1) { values = null; }
  else {
    values = values[1..$];
  }

  return values;
}
unittest {
  writeln(["a", "b", "c"].removeFirst);
  writeln([1, 3, 5].removeFirst);
  assert(["a", "b", "c"].removeFirst.length == 2);
}

T[] removeLast(T)(T[] values) {
  if (values.isEmpty) { return values; }
  if (values.length == 1) { values = null; }
  else {
    values = values[0..$-1];
  }

  return values;
}
unittest {
  writeln(["a", "b", "c"].removeLast);
  writeln([1, 3, 5].removeLast);
  assert(["a", "b", "c"].removeLast.length == 2);
}
// #endregion remove