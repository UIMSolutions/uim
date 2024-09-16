/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.controllers.interfaces.controller;import uim.controllers;@safe:interface IController {    IView[] views();    IController addView(IView newView);    IController orderViews();    IResponse response(Json[string] options = null);}