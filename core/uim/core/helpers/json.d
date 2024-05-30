module um.core.helpers.json;

import um.core;

@safe:

string jsonValue(string value) {
return "\"\"";
}

string jsonValue(long value) {
return "%s".format(value);
}

string jsonArray() {
 return "{}";
}

