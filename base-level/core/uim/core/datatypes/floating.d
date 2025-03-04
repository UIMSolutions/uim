/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.datatypes.floating;

import uim.core;

@safe:

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

V Null(V : float)() {
  return 0.0;
}

V Null(V : double)() {
  return 0.0;
}

// #region fuzzy
T fuzzy(T)(double fuzzyValue, T minValue, T maxValue, T minFuzzy = 0, T maxFuzzy = 1)
in {
  assert(minValue < maxValue, "toFuzzy(): minValue must be less than maxValue");
  assert(minFuzzy < maxFuzzy, "toFuzzy(): minFuzzy must be less than maxFuzzy");
}
do {
  if (fuzzyValue <= minFuzzy) {
    return minValue;
  }
  if (fuzzyValue >= maxFuzzy) {
    return maxValue;
  }

  auto fuzzyPos = (fuzzyValue - minFuzzy) / (maxFuzzy - minFuzzy);
  auto delta = maxValue - minValue;
  return to!T(minValue + (fuzzyPos * delta));
}

T toFuzzy(T)(T value, T minValue, T maxValue, T minFuzzy = 0, T maxFuzzy = 1)
in {
  assert(minValue < maxValue, "toFuzzy(): minValue must be less than maxValue");
  assert(minFuzzy < maxFuzzy, "toFuzzy(): minFuzzy must be less than maxFuzzy");
}
do {
  if (value <= minValue) {
    return minFuzzy;
  }

  if (value >= maxValue) {
    return maxFuzzy;
  }

  auto fuzzyPos = (value - minValue) / (maxValue - minValue);
  auto delta = maxFuzzy - minFuzzy;
  return minFuzzy + (fuzzyPos * delta);
}

unittest {
  assert(fuzzy(0, 0, 1) == 0);
  assert(fuzzy(1, 0, 1) == 1);

  assert(fuzzy(0, 10, 20) == 10);
  assert(fuzzy(.5, 10, 20) == 15);
  assert(fuzzy(1, 10, 20) == 20);

  assert(fuzzy(0, 1, 2) == 1);
  assert(fuzzy(2, 0, 1) == 1);
  assert(fuzzy(0.5, 0.0, 1.0) == 0.5);
}
// #endregion fuzzy
