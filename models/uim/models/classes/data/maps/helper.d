module uim.models.classes.data.maps.helper;

import uim.models;

@safe:

IData toMapData(IData[string] data) {
    auto map = MapData;
    // data.byKeyValue.each!(kv => map[kv.key] = kv.value);
    return map;
}

