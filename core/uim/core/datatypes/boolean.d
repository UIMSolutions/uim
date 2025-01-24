/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.datatypes.boolean;

@safe:
import uim.core;

unittest {
  writeln("-----  ", __MODULE__, "\t  -----");
}

V Null(V : bool)() {
  return false;
}

unittest {
  assert(Null!bool == false);
  assert(Null!bool != true);
}

// char[] BOOL(bool toogleValue) { return cast(char[])((toogleValue) ? `true`:`false`); }

/// Toggle boolean value (from true to false, false to true) -> in this function it's !value
bool toggle(bool value) {
  return !value;
}

bool toggle(ref bool value) {
  value = !value;
  return value;
}

unittest {
  assert(toggle(true) == false, "Error in toggle(bool)");
  assert(toggle(toggle(true)) == true, "Error in toggle(bool)");

  bool value = true;
  assert(value.toggle == false);
  assert(value == false);
}

/// Translates boolean to defined values
pure T translate(T)(bool value, T ifTrue, T ifFalse) {
  return (value) ? ifTrue : ifFalse;
}

unittest {
  assert(translate(true, "YES", "NO") == "YES", "Error in translate(bool, T, T)");
  assert(translate(false, "YES", "NO") == "NO", "Error in translate(bool, T, T)");
}

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
