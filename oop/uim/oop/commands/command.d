/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.commands.command;

import uim.oop;
@safe:

// Base class for commands
class DCommand : UIMObject, ICommand {
    mixin(CommandThis!());
/*    mixin TLocatorAware;
    mixin TLog; */

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    // Implement this method with your command`s logic.
    // abstract ulong execute(Json[string] options, IConsole console = null);
}
