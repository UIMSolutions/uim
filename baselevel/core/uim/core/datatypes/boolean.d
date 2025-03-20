/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.datatypes.boolean;

@safe:
import uim.core;

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

V Null(V : bool)() {
  return false;
}

unittest {
  assert(Null!bool == false);
  assert(Null!bool != true);
}

// char[] BOOL(bool toogleValue) { return cast(char[])((toogleValue) ? `true`:`false`); }

// #region toogle
/// Toggle boolean value (from true to false, false to true) -> in this function it's !value
bool toggle(bool value) {
  return !value;
}

unittest {
  assert(toggle(true) == false, "Error in toggle(bool)");
  assert(toggle(toggle(true)) == true, "Error in toggle(bool)");

  bool value = true;
  assert(value.toggle == false);
  /* assert(value == false);

  value = true;
  assert(value.toggle.toggle == true); */
}
// #endregion toogle

// #region translate
/// Translates boolean to defined values
pure T translateTo(T)(bool value, T trueValue, T falseValue) {
  return (value) ? trueValue : falseValue;
}

unittest {
  assert(translateTo(true, false, true) == false, "Error in translate(bool, T, T)");
  assert(translateTo(false, false, true) == true, "Error in translate(bool, T, T)");

  assert(translateTo(true, "YES", "NO") == "YES", "Error in translate(bool, T, T)");
  assert(translateTo(false, "YES", "NO") == "NO", "Error in translate(bool, T, T)");

  assert(translateTo(true, 1, 2) == 1, "Error in translate(bool, T, T)");
  assert(translateTo(false, 1, 2) == 2, "Error in translate(bool, T, T)");
}
// #endregion translateTo

/// Translates boolean to defined values
pure T fromBool(T)(bool value, T ifTrue, T ifFalse) {
  return (value) ? ifTrue : ifFalse;
}
///

unittest {
  assert(fromBool(true, "YES", "NO") == "YES", "Error in fromBool(bool, T, T)");
  assert(fromBool(false, "YES", "NO") == "NO", "Error in fromBool(bool, T, T)");
  assert(true.fromBool("YES", "NO") == "YES", "Error in fromBool(bool, T, T)");
  assert(false.fromBool("YES", "NO") == "NO", "Error in fromBool(bool, T, T)");
}

/// Translates value to bool
pure bool toBoolean(T)(T value, T ifValue) {
  return value == ifValue;
}
///

unittest {
  assert(!toBoolean("YES", "NO"), "Error in toBoolean(T, T)");
  assert(toBoolean("YES", "YES") == true, "Error in toBoolean(bool, T, T)");
}
