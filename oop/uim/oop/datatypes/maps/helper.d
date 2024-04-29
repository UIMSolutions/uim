module uim.oop.datatypes.maps.helper;

import uim.oop;

@safe:

IData toMapData(IData[string] data) {
    auto map = MapData;
    data.byKeyValue.each!(kv => map[kv.key] = kv.value);
    return map;
}

