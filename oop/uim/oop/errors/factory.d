/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.errors.factory;

import uim.oop;

@safe:

class DErrorFactory : DFactory!UIMError {
}
auto ErrorFactory() { return DErrorFactory.factory; }
