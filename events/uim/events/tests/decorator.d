/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.events.tests.decorator;

import uim.events;

@safe:

bool testDecorator(IDecorator decorator) {
    assert(decorator !is null, "Decorator is null");

    return true;
}
