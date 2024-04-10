module uim.commands.classes.commands.plugins.loaded;

import uim.commands;

@safe:

// Displays all currently loaded plugins.
class DPluginLoadedCommand : DCommand {
    mixin(CommandThis!("PluginLoaded"));

    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    static string defaultName() {
        return "plugin-loaded";
    }

    override int execute(IData[string] arguments, IConsoleIo aConsoleIo) {
        return super.execute(arguments, aConsoleIo);
    }

    /* 
    //  Displays all currently loaded plugins.
     * Params:
     * \UIM\Console\IData [string] arguments The command arguments.
     * @param \UIM\Console\IConsoleIo aConsoleIo The console io
  int execute(IData[string] arguments, IConsoleIo aConsoleIo) {
        loaded = Plugin. loaded();
        aConsoleIo.out ( loaded);

        return static . CODE_SUCCESS;
    }
    
    /**
     * Get the option parser.
    DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate) {
        parserToUpdate.description("Displays all currently loaded plugins.");

        return parserToUpdate;
    } */
}

mixin(CommandCalls!("PluginLoaded"));
