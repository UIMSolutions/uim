/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.tests.attribute;

import uim.models;

@safe:

bool testAttribute(IAttribute attribute) {
    assert(attribute !is null, "attribute is null");
    
    return true;
}