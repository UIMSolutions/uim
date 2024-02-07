module uim.core.datatypes.jstring;

import uim.core;

@safe:

IData[string] merge(IData[string] baseData, Json secondData, bool shouldOverwrite = false) {
  IData[string] result;

  baseData.byKeyValue
    .each!(kv => result[kv.key] = kv.value);

  secondData.byKeyValue
    .filter!(kv => shouldOverwrite || kv.key !in result)
    .each!(kv => result[kv.key] = kv.value);

  return result;
}

IData[string] update(IData[string] origin, IData[string] additional) {
  IData[string] updated = origin.dup;
  additional.byKeyValue
    .each!(kv => updated[kv.key] = kv.value);

  return updated;
}

IData[string] copy(IData[string] origin) {
  IData[string] result;
  origin.byKeyValue
    .each!(kv => result[kv.key] = kv.value);

  return result;
}