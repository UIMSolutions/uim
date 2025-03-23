/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.validators;

version (test_uim_oop) {
    import std.stdio;
    unittest {
        writeln("-----  ", __MODULE__, "\t  -----");
    }
}

public {
    import uim.oop.validators.validator;
}

public {
    import uim.oop.validators.collection;
    import uim.oop.validators.factory;
    import uim.oop.validators.interfaces;
    import uim.oop.validators.mixins;
    import uim.oop.validators.registry;
}