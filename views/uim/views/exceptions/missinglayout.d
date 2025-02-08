/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.exceptions.missinglayout;

import uim.views;

@safe:

// Used when a layout file cannot be found.
class DMissingLayoutException : DMissingTemplateException {
    mixin(ExceptionThis!("MissingLayout"));
    
    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        templateType("Layout");

        return true;
    }
}

mixin(ExceptionCalls!("MissingLayout"));
