/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.exceptions.missingelement;    

import uim.views;

@safe:

// Used when an element file cannot be found.
class DMissingElementException : DMissingTemplateException {
    mixin(ExceptionThis!("MissingElement"));
    override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

        templateType("Element");

        return true;
    }
}

mixin(ExceptionCalls!("MissingElement"));
