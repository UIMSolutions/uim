module uim.core.convert.jsonmap;

import uim.core;
@safe:

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

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

Json toJson(Json[string] map) {
  Json json = Json.emptyObject;  
  map.each!((key, value) => json[key] = value);
  return json;
}