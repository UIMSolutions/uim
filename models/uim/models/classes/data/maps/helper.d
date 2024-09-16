/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.classes.data.maps.helper;import uim.models;@safe:IData toMapData(IData[string] data) {    auto map = MapData;    // data.byKeyValue.each!(kv => map[kv.key] = kv.value);    return map;}