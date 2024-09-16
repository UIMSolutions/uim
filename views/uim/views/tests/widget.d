/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.tests.widget;import uim.views;@safe:bool testWidget(IWidget widgetToTest) {    assert(widgetToTest !is null, "In testWidget: widgetToTest is null");        return true;}