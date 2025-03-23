/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.tests.exception;

import uim.oop;

@safe:

version (test_uim_oop) {
    import std.stdio;
    unittest {
        writeln("-----  ", __MODULE__, "\t  -----");
    }
}

bool testException(IException exception) {
    if (exception is null) {
        return false;
    }

    return true;
}
