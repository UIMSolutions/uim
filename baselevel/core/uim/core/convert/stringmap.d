module uim.core.convert.stringmap;

import uim.core;

@safe:

// toStringMap


STRINGAA toStringMap(Json[string] map) {
  STRINGAA stringMap;
  map.byKeyValue
    .each!(kv => stringMap[kv.key] = kv.value.to!string);
  return stringMap;
}

unittest {
  Json[string] jsonMap = [
    "key1": Json("value1"),
    "key2": Json("value2")
  ];

  STRINGAA expectedStringMap = [
    "key1": "value1",
    "key2": "value2"
  ];

  assert(toStringMap(jsonMap) == expectedStringMap);
}
