/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.mixins.keys;

import uim.core;
@safe:


string setKeys(string returnType, string valueType, string plural, string singular) {
    return `
        {returnType} setAll{plural}({valueType}[] values) {
            
            return this;
        }
    `
    .replace("{returnType}", returnType)
    .replace("{valueType}", valueType)
    .replace("{plural}", plural)
    .replace("{singular}", singular);
}