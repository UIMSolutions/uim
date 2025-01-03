/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.mixins.formatter;

import uim.i18n;
@safe:

string i18nFormatterThis(string name = null) {
    string fullName = name ~ "I18NFormatter";
    return objThis(fullName);
}

template I18NFormatterThis(string name = null) {
    const char[] I18NFormatterThis = i18nFormatterThis(name);
}

string formatterCalls(string name) {
    string fullName = name ~ "I18NFormatter";
    return objCalls(fullName);
}

template FormatterCalls(string name) {
    const char[] FormatterCalls = formatterCalls(name);
}