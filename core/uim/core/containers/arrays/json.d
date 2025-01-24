/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.containers.arrays.json;

import uim.core;

@safe:

unittest {
  writeln("-----  ", __MODULE__, "\t  -----");
}

string[] getStringArray(Json[] values) {
  return values
    .filter!(value => value.isString)
    .map!(value => value.get!string)
    .array;
}

string[] toStringArray(Json[] values) {
  return values.map!(value => value.to!string).array;
}
