/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.mixins.element;import uim.models;@safe: string elementThis(string name = null) {    string fullName = name ~ "Element";    return objThis(fullName);}template elementThis(string name = null) {    const char[] elementThis = elementThis(name);}string elementCalls(string name) {    string fullName = name ~ "Element";    return objCalls(fullName);}