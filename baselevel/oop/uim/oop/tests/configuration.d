/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.tests.configuration;

mixin(Version!"test_uim_oop");

import uim.oop;
@safe:

bool testConfiguration(IConfiguration config) {
    config.entries([
        "a": Json("A"),
        "b": Json("B"),
        "1": Json(1),
        "1.1": Json(1.1),
        "true": Json(true),
        "false": Json(false),
        "null": Json(null)
    ]);

    assert(config.getStringEntry("a") == "A", config.name);
    assert(config.getStringEntry("b") == "B", config.name);
    
    assert(config.getStringEntry("c") == "C", config.name);
    assert(config.getStringEntry("c") != "X", config.name);

    return true;
}