/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.helpers.json;

import uim.core;

@safe:

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}
string jsonValue(bool value) {
    return value ? "true" : "false";
}

unittest {
}

string jsonValue(string value) {
    return "\"%s\"".format(value);
}

unittest {
}

string jsonValue(long value) {
    return "%s".format(value);
}

unittest {
}

string jsonArray(T)(T[] values) {
    values.map!(value => jsonValue(value));
    return "[]";
}

unittest {
}

string jsonObject() {
    return "{}";
}

unittest {
}
