module uim.core.convert;

import uim.core;
@safe:

STRINGAA toStringMap(Json[string] map) {
  STRINGAA stringMap;
  map.byKeyValue
    .each!(kv => stringMap[kv.key] = kv.value.to!string);
  return stringMap;
}
