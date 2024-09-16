/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.tests.helper;import uim.views;@safe:bool testHelper(IFormHelper helperToTest) {    assert(helperToTest !is null, "In testHelper: helperToTest is null");        return true;}