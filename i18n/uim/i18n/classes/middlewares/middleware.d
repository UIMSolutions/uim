/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.classes.middlewares.middleware;import uim.i18n;@safe:class D18NMiddleware : II18NMiddleware {    mixin TConfigurable;    this() {        initialize;    }    bool initialize(Json[string] initData = null) {        configuration(MemoryConfiguration);        configuration.data(initData);                return true;    }}