/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.commands.plugins.loaded;

import uim.commands;

@safe:

// Displays all currently loaded plugins.
class DPluginLoadedCommand : DCommand {
    mixin(CommandThis!("PluginLoaded"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    static string defaultName() {
        return "plugin-loaded";
    }

    override ulong execute(Json[string] arguments, IConsoleIo consoleIo) {
        return super.execute(arguments, consoleIo);
    }

    /* 
    //  Displays all currently loaded plugins.
     * Params:
     * \UIM\Console\Json[string] arguments The command arguments.
  override ulong execute(Json[string] arguments, IConsole aConsole = null) {
        loaded = Plugin. loaded();
        aConsoleIo.out (loaded);

        return static . CODE_SUCCESS;
    }
    
    // Get the option parser.
    DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate) {
        parserToUpdate.description("Displays all currently loaded plugins.");

        return parserToUpdate;
    } */
}

mixin(CommandCalls!("PluginLoaded"));
