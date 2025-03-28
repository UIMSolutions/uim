/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.tests.configuration;

mixin(Version!"test_uim_oop");

import uim.oop;
@safe:

bool testConfiguration(IConfiguration configuration) {
    configuration.entries([
        "a": Json("A"),
        "b": Json("B"),
        "1": Json(1),
        "1.1": Json(1.1),
        "true": Json(true),
        "false": Json(false),
        "null": Json(null)
    ]);

    configuration.defaults([
        "a": Json("A"),
        "c": Json("C")
    ]);

    assert(configuration.defaultString("c") == "C", configuration.name~": "~`configuration.defaultString("c") == "C"`);

    assert(configuration.defaultString("c") == "C", configuration.name~": "~`configuration.defaultString("c") == "C"`);

    assert(configuration.entryString("a") == "A", configuration.name);
    assert(configuration.entryString("b") == "B", configuration.name);
    
    assert(configuration.entryString("c") == "C", configuration.name);
    assert(configuration.entryString("c") != "X", configuration.name);

    assert(configuration.default_("a").to!string == "A", configuration.name);
    assert(configuration.defaultString("c") == "C", configuration.name);

    assert(configuration.hasAnyDefaults(["a", "x"]), configuration.name);
    assert(!configuration.hasAnyDefaults(["x", "y"]), configuration.name);

    assert(configuration.hasAllDefaults(["a", "c"]));
    assert(!configuration.hasAllDefaults(["a", "x"]));

    return true;
}