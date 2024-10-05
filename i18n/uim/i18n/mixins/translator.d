/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.mixins.translator;

import uim.i18n;

@safe:

string translatorThis(string name = null) {
    string fullName = name ~ "Translator";
    return objThis(fullName);
}

template TranslatorThis(string name = null) {
    const char[] TranslatorThis = translatorThis(name);
}

string translatorCalls(string name) {
    string fullName = name ~ "Translator";
    return objCalls(fullName);
}

template TranslatorCalls(string name) {
    const char[] TranslatorCalls = translatorCalls(name);
}
