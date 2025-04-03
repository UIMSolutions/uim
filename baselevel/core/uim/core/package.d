/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core;

mixin(ImportPhobos!());

public import vibe.d;

public {
  import uim.core.classes;
  import uim.core.containers;
  import uim.core.consts;
  import uim.core.convert;
  import uim.core.datatypes;
  import uim.core.dlang;
  import uim.core.enumerations;
  import uim.core.helpers;
  import uim.core.io;
  import uim.core.mixins;
  import uim.core.web;
  import uim.core.tests;
}

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

@safe:
alias STRINGAA = string[string];
alias INTAA = int[int];
alias DOUBLEAA = double[double];

const DIR_SEPARATOR = "\\";



/+ +/
/// select values in array
// get all values in array are equal to value
T[] eqValues(T)(T value, T[] values) {
  return values
    .filter!(v => value == v)
    .array;
}
// get all values in array are not equal to value
T[] neqValues(T)(T checkValue, T[] values) {
  return values
    .filter!(v => checkValue != v)
    .array;
}

// get all values in array are greater then value
T[] gtValues(T)(T value, T[] values) if (isNumeric!T) {
  return values
    .filter!(v => value > v)
    .array;
}
// get all values in array are greater equal value
T[] geValues(T)(T value, T[] values) if (isNumeric!T) {
  return values
    .filter!(v => value >= v)
    .array;
}
// get all values in array are less then value
T[] ltValues(T)(T value, T[] values) if (isNumeric!T) {
  return values
    .filter!(v => value < v)
    .array;
}
// get all values in array are less equal value
T[] leValues(T)(T value, T[] values) if (isNumeric!T) {
  return values
    .filter!(v => value <= v)
    .array;
}

/// compare values in array
// all values in array are equal to value
bool allEqual(T)(T[] values, T aValue) {
  return values
    .filter!(value => value != aValue).array.length == 0;
}

unittest {
  assert([1, 1, 1].allEqual(1));
  assert(![1, 2, 1].allEqual(1));
}

bool equalAny(T)(T[] values, T aValue) {
  return (values.filter!(value => value == aValue).array.length > 0);
}
///
unittest {
  assert([1, 1, 1].equalAny(1));
  assert(![1, 2, 1].equalAny(3));
  assert([1, 2, 1].equalAny(1));
}

// all values in array are not equal to value
bool nallEqual(T)(T aValue, T[] values) {
  return values.all!(value => aValue != value);
}
/// 
unittest {
  assert(1.nallEqual([2, 3]));
}

// all values in array are greater then value
bool greaterThenAll(T)(T[] baseValues, T value) if (isNumeric!T) {
  return baseValues.all!(base => greaterThen(base, value));
}
/// 
unittest {
  assert([2, 3, 4].greaterThenAll(1));
  assert(![1, 2, 1].greaterThenAll(1));
}

bool greaterThenAny(T)(T[] baseValues, T value) if (isNumeric!T) {
  return baseValues.any!(base => greaterThen(base, value));
}

unittest {
  assert([2, 3, 4].greaterThenAny(1));
  assert([1, 2, 1].greaterThenAny(1));
  assert(![1, 2, 1].greaterThenAny(3));
}

bool greaterThen(T)(T base, T value) if (isNumeric!T) {
  return (base > value);
}

// all values in array are greater equal value
bool allGreaterEqual(T)(T checkValue, T[] values) if (isNumeric!T) {
  return values.all!(value => checkValue >= value);
}
unittest {
  assert(3.allGreaterEqual([1, 2, 3]));
}

// all values in array are less then value
bool allLowerThen(T)(T value, T[] values) if (isNumeric!T) {
  foreach (v; values)
    if (value < v)
      continue;
    else
      return false;
  return true;
}
// all values in array are less equal value
bool allLowerEqual(T)(T value, T[] values) if (isNumeric!T) {
  foreach (v; values)
    if (value <= v)
      continue;
    else
      return false;
  return true;
}

bool equal(T)(T[] leftCells, T[] rightCells) {
  if (leftCells.length == rightCells.length) {
    foreach (i; 0 .. leftCells.length)
      if (leftCells[i] != rightCells[i]) {
        return false;
      }
    return true;
  }
  return false;
}

T limit(T)(T value, T left, T right) if (isNumeric!T) {
  T result = value;
  if (left < right) {
    if (result > right)
      result = right;
    if (result < left)
      result = left;
  } else {
    if (result > left)
      result = left;
    if (result < right)
      result = right;
  }
  return result;
}

T[2] arrayLimits(T, S)(T from, T to, S[] values) if (isNumeric!T) {
  return arrayLimits(from, to, 0, values.length);
}

T[2] arrayLimits(T)(T from, T to, T left, T right) if (isNumeric!T) {
  T[2] result;
  result[0] = limit(from, left, right - 1);
  result[1] = limit(to, left, right);
  return result;
}

string[] stringAA2Array(string[string] values, string sep = ": ") {
  string[] results;
  foreach (k, v; values)
    results ~= k ~ sep ~ v;
  return results;
}

template CascadeNotNull(alias A) {
  const bool CascadeNotNull = (A) ? true : false;
}

template CascadeNotNull(alias A, alias B) {
  const bool CascadeNotNull = (A) ? (CascadeNotNull!(A.B)) : false;
}

template CascadeNotNull(alias A, alias B, alias C) {
  const bool CascadeNotNull = (CascadeNotNull!(A, B)) ? (CascadeNotNull!(A.B, C)) : false;
}

template CascadeNotNull(alias A, alias B, alias C, alias D) {
  const bool CascadeNotNull = (CascadeNotNull!(A, B, C)) ? (CascadeNotNull!(A.B.C, D)) : false;
}


  unittest {
    assert(stringAA2Array(["A": "B", "C": "D"], "/") == ["A/B", "C/D"]);
  }


void debugFunctionCall(string text) {
  /*   debug writeln(StyledString(text)
    .setForeground(AnsiColor.black)
    .setBackground(AnsiColor.yellow)); */
  debug writeln(text);
}

void debugMethodCall(string text) {
  /*   debug writeln(StyledString(text)
    .setForeground(AnsiColor.black)
    .setBackground(AnsiColor.white)); */
  debug writeln(text);
}
