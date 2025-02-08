/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.mixins.parser;

import uim.i18n;
@safe:

string i18nParserThis(string name = null) {
    string fullName = name ~ "I18NParser";
    return objThis(fullName);
}

template I18NParserThis(string name = null) {
    const char[] I18NParserThis = i18nParserThis(name);
}

string i18nparserCalls(string name) {
    string fullName = name ~ "I18NParser";
    return objCalls(fullName);
}

template I18NParserCalls(string name) {
    const char[] I18NParserCalls = i18nparserCalls(name);
}