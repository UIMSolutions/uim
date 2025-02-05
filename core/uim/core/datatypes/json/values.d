module uim.core.datatypes.json.values;

import uim.core;

@safe:

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// #region values
// Get values from json object
Json[] values(Json json) {
  return json.isObject
    ? json.byKeyValue.map!(kv => kv.value).array : null;
}
unittest {
  auto json = parseJsonString(`{"a": "b", "c": 1}`);
  writeln(json.values);
  assert(json.values.hasAll(Json("b"), Json(1)));
  assert(!json.values.hasAll(Json("b"), Json("x")));
}
// #endregion values

bool hasAllValues(Json json, Json[] values, bool deepSearch = false) {
  foreach (value; values)
    if (!hasValue(json, value, deepSearch)) {
      return false;
    }
  return true;
}
///

unittest {
  auto json = parseJsonString(`{"a": "b", "c": {"d": 1}, "e": ["f", {"g": "h"}], "i": "j"}`);
  assert(json.hasAllValues([Json("b"), Json("j")]));
  assert(json.hasAllValues([Json("h"), Json(1)], true));
}

// Search if jsonData has any of the values
bool hasAnyValue(Json jsonData, Json[] values, bool deepSearch = false) {
  return values.any!(value => hasValue(jsonData, value, deepSearch));
}
///

unittest {
  auto json = parseJsonString(`{"a": "b", "c": {"d": 1}, "e": ["f", {"g": "h"}], "i": "j"}`);
  assert(json.hasAllValues([Json("b"), Json("j")]));
  assert(json.hasAllValues([Json("h"), Json(1)], true));
}

// Search if jsonData has value
bool hasValue(Json jsonData, Json value, bool deepSearch = false) {
  if (jsonData.isObject) {
    foreach (kv; jsonData.byKeyValue) {
      if (kv.value == value) {
        return true;
      }
      if (deepSearch) {
        auto result = kv.value.hasValue(value, deepSearch);
        if (result) {
          return true;
        }
      }
    }
  }

  if (deepSearch) {
    if (jsonData.isArray) {
      for (size_t i = 0; i < jsonData.length; i++) {
        const result = jsonData[i].hasValue(value, deepSearch);
        if (result) {
          return true;
        }
      }
    }
  }

  return false;
}
///
unittest {
  auto json = parseJsonString(`{"a": "b", "c": {"d": 1}, "e": ["f", {"g": "h"}]}`);
  assert(json.hasValue(Json("b")));
  assert(json.hasValue(Json("h"), true));
  assert(!json.hasValue(Json("x")));
  assert(!json.hasValue(Json("y"), true));
}
