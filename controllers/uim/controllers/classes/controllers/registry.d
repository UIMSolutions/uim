/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.controllers.classes.controllers.registry;

import uim.controllers;

@safe:

class DControllerRegistry : DObjectRegistry!DController {
}

auto ControllerRegistry() { // for Singleton
    return DControllerRegistry.registration;
}

unittest { // Singleton tests
    assert(ControllerRegistry.length == 0);
    assert(ControllerRegistry.register("test", new DController).length == 1);
    assert(ControllerRegistry.remove("test").length == 0);
}

unittest { // Instance tests
    auto registry = new DControllerRegistry;
    assert(registry.length == 0);
    assert(registry.register("test", new DController).length == 1);
    assert(registry.remove("test").length == 0);
}

unittest { // Singleton tests
    assert(ControllerRegistry.length == 0);
    assert(ControllerRegistry.register("test", new DController).length == 1);
    assert(ControllerRegistry.remove("test").length == 0);
}

unittest { // combined tests
    auto registry = new DControllerRegistry;
    assert(registry.length == 0);
    assert(ControllerRegistry.length == 0);

    assert(registry.register("test", new DController).length == 1);
    assert(ControllerRegistry.length == 0);

    assert(registry.remove("test").length == 0);
    assert(ControllerRegistry.length == 0);
}