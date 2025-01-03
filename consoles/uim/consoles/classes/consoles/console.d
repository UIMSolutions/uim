/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.classes.consoles.console;

import uim.consoles;

@safe:

// Object wrapper for interacting with stdin
class DConsole : UIMObject, IConsole {
    mixin(ConsoleThis!());

    /*    mixin TLocatorAware;
    mixin TLog; */
}
