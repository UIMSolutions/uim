module uim.commands.plugins.assetscopy;

import uim.commands;

@safe:

// Command for copying plugin assets to app`s webroot.
class PluginAssetsCopyCommand : Command {
   mixin(CommandThis!("PluginAssetsCopyCommand"));

  	override bool initialize(IConfigData[string] configData = null) {
		if (!super.initialize(configData)) { return false; }
		
		return true;
	}

    mixin PluginAssetsTemplate();

    static string defaultName() {
        return "plugin assets copy";
    }
    
    /**
     * Copying plugin assets to app`s webroot. For vendor namespaced plugin,
     * parent folder for vendor name are created if required.
     */
  int execute(Arguments commandArguments, ConsoleIo aConsoleIo) {
        this.io = aConsoleIo;
        this.args = commandArguments;

        auto name = commandArguments.getArgument("name");
        auto shouldOverwrite = (bool)commandArguments.getOption("overwrite");
       _process(_list(name), true, shouldOverwrite);

        return CODE_SUCCESS;
    }
    
    /**
     * Get the option parser.
     * Params:
     * \UIM\Console\ConsoleOptionParser parserToUpdate The option parser to update
     */
    ConsoleOptionParser buildOptionParser(ConsoleOptionParser parserToUpdate){
        parserToUpdate.description([
            "Copy plugin assets to app\`s webroot.",
        ]).addArgument("name", [
            "help": "A specific plugin you want to copy assets for.",
            "required": false,
        ]).addOption("overwrite", [
            "help": "Overwrite existing symlink / folder / files.",
            "default": false,
            "boolean": true,
        ]);

        return parserToUpdate;
    }
}
