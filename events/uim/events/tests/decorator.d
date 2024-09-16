/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.events.tests.decorator;import uim.events;@safe:bool testDecorator(IDecorator decoratorToTest) {    assert(decoratorToTest !is null, "In testDecorator: decoratorToTest is null");        return true;}