/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (UIManufaktur)										                         * 
***********************************************************************************************************************/
module uim.core.datatypes.floating;

@safe:
import uim.core;

T fuzzy(T)(T value, T minLimit, T maxLimit, T minFactor = 0, T maxFactor = 1)
    if (isFloatingPoint!T) {

  if (value < minLimit) {
    return minFactor;
  }
  if (value > maxLimit) {
    return maxFactor;
  }

  return to!T(minFactor + (maxFactor - minFactor) * (value - minLimit) / (maxLimit - minLimit));
}

unittest {
  /* 	assert(fuzzy(0, 0, 1) == 0);
	assert(fuzzy(1, 0, 1) == 1);
	assert(fuzzy(0, 1, 2) == 1);
	assert(fuzzy(2, 0, 1) == 1);
	assert(fuzzy(0.5, 0.0, 1.0) == 0.5); */
}

/* string toString(T)(T value, size_t length = 0, string fillTxt = "0") {
//    if (isFloatingPoint!T) {
  string result = fill(length, fillTxt);

  import std.conv;

  string convert = to!string(value);
  result = convert.length < length
    ? result[0 .. $ - convert.length] ~ convert : convert;

  return result;
} */

unittest {
  // TODO
  // writeln((1.01).toString);
  //   assert((1.0).toString == "1.0");
  //   assert((1.0).toString == "1.0");
  //   assert((1.0).toString(10, "X") == "XXXXXXX1.0");
}
