/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module commands.uim.commands.interfaces.interfaces;

import uim.oop;
@safe:

interface ICommand : INamed {
    bool execute(Json[string] options = null);
}