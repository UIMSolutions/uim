/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.classes.consoles.registry;

import uim.consoles;
@safe:

class DConsoleRegistry : DObjectRegistry!DConsole {
}
auto ConsoleRegistry() { return DConsoleRegistry.registry; }