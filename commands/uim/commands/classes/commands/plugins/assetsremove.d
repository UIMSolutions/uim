module uim.commands.classes.commands.plugins.assetsremove;

import uim.commands;

@safe:

// Command for removing plugin assets from app`s webroot.
class DPluginAssetsRemoveCommand : DCommand {
   mixin(CommandThis!("PluginAssetsRemove"));

    mixin TPluginAssets;

  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}

    static string defaultName() {
        return "plugin-assets remove";
    }


    // Remove plugin assets from app`s webroot.
  int execute(IData[string] arguments, IConsoleIo aConsoleIo) {
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
        ]);
        aParser.addArgument("name", [
            "help": StringData("A specific plugin you want to remove."),
            "required": BooleanData(false),
        ]);

        return aParser;
    } 
}
mixin(CommandCalls!("PluginAssetsRemove"));
