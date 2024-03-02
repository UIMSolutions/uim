module uim.commands.plugins.loaded_;

import uim.commands;

@safe:

// Displays all currently loaded plugins.
class PluginLoadedCommand : Command {
   mixin(CommandThis!("PluginLoaded"));

  	override bool initialize(IConfigData[string] configData = null) {
		if (!super.initialize(configData)) { return false; }
		
		return true;
	}

    static string defaultName() {
        return "plugin loaded";
    }
    
    //  Displays all currently loaded plugins.
     * Params:
     * \UIM\Console\Arguments commandArguments The command arguments.
     * @param \UIM\Console\ConsoleIo aConsoleIo The console io
     */
  int execute(Arguments commandArguments, ConsoleIo aConsoleIo) {
        loaded = Plugin. loaded();
        aConsoleIo.out ($loaded);

        return static . CODE_SUCCESS;
    }
    
    /**
     * Get the option parser.
    ConsoleOptionParser buildOptionParser(ConsoleOptionParser parserToUpdate) {
        parserToUpdate.description("Displays all currently loaded plugins.");

        return parserToUpdate;
    }
}
