/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module views.uim.views.registries.view;

import uim.views;

@safe:

class DViewRegistry : DObjectRegistry!DView {
}

auto ViewRegistry() { // for Singleton
    return DViewRegistry.registration;
}