module uim.core.datatypes.jstring;

import uim.core;

@safe:

Json[string] merge(Json[string] baseData, Json secondData, bool shouldOverwrite = false) {
  Json[string] result;

  baseData.byKeyValue
    .each!(kv => result[kv.key] = kv.value);

  secondData.byKeyValue
    .filter!(kv => shouldOverwrite || kv.key !in result)
    .each!(kv => result[kv.key] = kv.value);

  return result;
}

Json[string] update(Json[string] origin, Json[string] additional) {
  Json[string] updated = origin.dup;
  additional.byKeyValue
    .each!(kv => updated[kv.key] = kv.value);

  return updated;
}

Json[string] copy(Json[string] origin) {
  Json[string] result;
  origin.byKeyValue
    .each!(kv => result[kv.key] = kv.value);

  return result;
}