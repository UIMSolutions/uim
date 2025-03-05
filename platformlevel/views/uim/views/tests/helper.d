/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.tests.helper;

import uim.views;

@safe:

bool testHelper(IFormHelper formHelper) {
    assert(formHelper !is null, "FormHelper is null");
    
    return true;
}