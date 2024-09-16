/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.controllers.tests.controller;import uim.controllers; @safe:bool testController(IController controllerToTest) {    assert(controllerToTest !is null, "In testController: controllerToTest is null");        return true;}