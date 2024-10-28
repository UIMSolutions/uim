/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.controllers.classes.controllers.registry;

import uim.controllers;

@safe:

class DControllerRegistry : DObjectRegistry!DController {
    static DControllerRegistry registry;
}

auto ControllerRegistry() {
    return registry is null
        ? registry = new DControllerRegistry
        : registry;
}