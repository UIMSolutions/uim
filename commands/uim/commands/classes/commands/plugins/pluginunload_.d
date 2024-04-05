module uim.commands.classes.commands.plugins.pluginunload_;

import uim.commands;

@safe:

// Command for unloading plugins.
class DPluginUnloadCommand : DCommand {
   mixin(CommandThis!("PluginUnload"));

  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}

    // TODO protected string configDataFile = CONFIG ~ "plugins.d";
 
    static string defaultName() {
        return "plugin-unload";
    }

/* 
  int execute(IData[string] arguments, IConsoleIo aConsoleIo) {
        auto plugin = to!string(commandArguments.getArgument("plugin"));

        result = this.modifyConfigFile(plugin);
        if (result is null) {
             aConsoleIo.success("Plugin removed from `CONFIG/plugins.d`");

            return CODE_SUCCESS;
        }
         aConsoleIo.writeErrorMessages(result);

        return CODE_ERROR;
    }
    
    //  Modify the plugins config file.
    protected string modifyConfigFile(string pluginName) {
        auto configData = @include this.configFile;
        if (!configData.isArray) {
            return "`CONFIG/plugins.d` not found or does not return an array";
        }
        configData = Hash.normalize(configData);
        if (!array_key_exists(pluginName, configData)) {
            return "plugin-`%s` could not be found".format(pluginName);
        }
        configData.remove(pluginName);

        if (class_exists(VarExporter.classname)) {
            array = VarExporter.export(configData);
        } else {
            array = var_export(configData, true);
        }
        contents = "" ~ "\n" ~ "return " ~ array ~ ";";

        if (file_put_contents(this.configFile, contents)) {
            return null;
        }
        return "Failed to update `CONFIG/plugins.d`";
    }
    
    /**
     * Get the option parser.
     * Params:
     * \UIM\Console\ConsoleOptionParser  aParser The option parser to update
     * /
    ConsoleOptionParser buildOptionParser(ConsoleOptionParser  aParser) {
         aParser.description([
            "Command for unloading plugins.",
        ])
        .addArgument("plugin", [
            "help": 'Name of the plugin to unload.",
            "required": BooleanData(true),
        ]);

        return aParser;
    } */
}
mixin(CommandCalls!("PluginUnload"));
