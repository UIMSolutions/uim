module uim.views.mixins.association;

/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.orm.mixins.association;

import uim.orm;

@safe:

string associationThis(string name = null) {
    string fullName = name ~ "Association";
    return objThis(fullName);
}

template AssociationThis(string name = null) {
    const char[] AssociationThis = associationThis(name);
}

string associationCalls(string name) {
    string fullName = name ~ "Association";
    return objCalls(fullName);
}

template AssociationCalls(string name) {
    const char[] AssociationCalls = associationCalls(name);
}
