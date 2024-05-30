module um.core.helpers.json;

import um.core;

@safe:

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

