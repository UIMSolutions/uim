/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.plugins.loaded;

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

    override bool execute(Json[string] arguments, IConsole consoleIo) {
        /* return super.execute(arguments, consoleIo); */
        return true;
    }

    /* 
    //  Displays all currently loaded plugins.
     * Params:
     * \UIM\Console\Json[string] arguments The command arguments.
  override bool execute(Json[string] arguments, IConsole console = null) {
        loaded = Plugin. loaded();
        aConsole.out (loaded);

        return static . true;
    }
    
    // Get the option parser.
    DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate) {
        parserToUpdate.description("Displays all currently loaded plugins.");

        return parserToUpdate;
    } */
}

mixin(CommandCalls!("PluginLoaded"));
