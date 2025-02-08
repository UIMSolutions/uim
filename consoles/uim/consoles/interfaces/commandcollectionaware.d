/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.interfaces.commandcollectionaware;

import uim.consoles;

@safe:

// An interface for shells that take a CommandCollection during initialization.
interface IConmsoleCommandCollectionAware {
    // Set the command collection being used.
    // TODO void commandCollection(CommandCollection newCollection);
}
