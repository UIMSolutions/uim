/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt rest.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.configurations.engines.rest;

mixin(Version!"test_uim_oop");

import uim.oop;
@safe:

class DRestConfigEngine : DConfigEngine {
    mixin(ConfigEngineThis!("Rest"));    
}
mixin(ConfigEngineCalls!("Rest"));    
