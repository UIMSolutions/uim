/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.errors.registry;

import uim.oop;

@safe:

class DErrorRegistry : DObjectRegistry!UIMError {
}

auto ErrorRegistry() {
    return DErrorRegistry.registry;
}
