/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.controllers.tests.component;

import uim.controllers;

@safe:

bool testComponent(IComponent componentToTest) {
    assert(componentToTest !is null, "In testComponent: componentToTest is null");

    return true;
}
