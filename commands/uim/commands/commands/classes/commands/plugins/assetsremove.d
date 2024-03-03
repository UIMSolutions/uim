module uim.commands.plugins.assetsremove;

import uim.commands;

@safe:

// Command for removing plugin assets from app`s webroot.
class PluginAssetsRemoveCommand : Command {
   mixin(CommandThis!("PluginAssetsRemoveCommand"));

  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}

    mixin PluginAssetsTemplate();
 
    static string defaultName() {
        return "plugin assets remove";
    }
    
    // Remove plugin assets from app`s webroot.
  int execute(Arguments commandArguments, ConsoleIo aConsoleIo) {
        this.io = aConsoleIo;
        this.args = commandArguments;

        auto name = commandArguments.getArgument("name");
        plugins = _list(name);

        plugins.byKeyValue
            .each!((pluginConfigData) {
                this.io.writeln();
                this.io.writeln("For plugin: " ~ pluginConfigData.key);
                this.io.hr();

                _remove(pluginConfigData.value);
            });
        this.io.writeln();
        this.io.writeln("Done");

        return CODE_SUCCESS;
    }

    // Get the option parser.
    ConsoleOptionParser buildOptionParser(ConsoleOptionParser aParser) {
        aParser.description([
            "Remove plugin assets from app\`s webroot.",
        ]).addArgument("name", [
            "help": "A specific plugin you want to remove.",
            "required": false,
        ]);

        return aParser;
    }
}
