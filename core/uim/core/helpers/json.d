module um.core.helpers.json;

import um.core;

@safe:

string jsonValue(bool value) {
return value ? "true" : "false";
}

string jsonValue(string value) {
return "\"%s\"".format(value);
}

string jsonValue(long value) {
return "%s".format(value);
}

string jsonArray(T)(T[] values) {
 values.map!(value => jsonValue(value));
 return "[]";
}

string jsonObject() {
 return "{}";
}


