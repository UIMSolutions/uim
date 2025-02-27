/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.logging.tests.engine;

import uim.logging;
@safe:

bool testLogEngine(ILogEngine engine) {
    assert(engine !is null, "testLogEngine: engine is null");
    
    return true;
}