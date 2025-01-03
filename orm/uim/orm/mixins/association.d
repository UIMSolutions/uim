/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.orm.mixins.association;

import uim.orm;

@safe:

string ormAssociationThis(string name = null) {
    string fullName = name ~ "ORMAssociation";
    return objThis(fullName);
}

template ORMAssociationThis(string name = null) {
    const char[] ORMAssociationThis = ormAssociationThis(name);
}

string ormAssociationCalls(string name) {
    string fullName = name ~ "ORMAssociation";
    return objCalls(fullName);
}

template ORMAssociationCalls(string name) {
    const char[] ORMAssociationCalls = ormAssociationCalls(name);
}
