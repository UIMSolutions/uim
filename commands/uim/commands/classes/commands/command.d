/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.commands.command;

import uim.commands;
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
    bool execute(Json[string] options, IConsole console = null) {
        return true;
    }
}
