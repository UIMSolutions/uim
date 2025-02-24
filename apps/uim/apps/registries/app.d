/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module apps.uim.apps.registries.app;

import uim.apps;

@safe:

class DAppRegistry : DObjectRegistry!DApp {
}

auto AppRegistration() { // for Singleton
    return DAppRegistry.registration;
}

unittest { // Singleton tests
    assert(AppRegistration.length == 0);
    assert(AppRegistration.register("test", new DApp).length == 1);
    assert(AppRegistration.remove("test").length == 0);
}

unittest { // Instance tests
    auto registry = new DAppRegistry;
    assert(registry.length == 0);
    assert(registry.register("test", new DApp).length == 1);
    assert(registry.remove("test").length == 0);
}

unittest { // Singleton tests
    assert(AppRegistration.length == 0);
    assert(AppRegistration.register("test", new DApp).length == 1);
    assert(AppRegistration.remove("test").length == 0);
}

unittest { // combined tests
    auto registry = new DAppRegistry;
    assert(registry.length == 0);
    assert(AppRegistration.length == 0);

    assert(registry.register("test", new DApp).length == 1);
    assert(AppRegistration.length == 0);

    assert(registry.remove("test").length == 0);
    assert(AppRegistration.length == 0);
}