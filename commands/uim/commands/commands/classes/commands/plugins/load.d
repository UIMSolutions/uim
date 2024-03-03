module uim.commands.plugins.load;

import uim.commands;

@safe:

// Command for loading plugins.
class PluginLoadCommand : Command {
   mixin(CommandThis!("PluginLoadCommand"));

  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(configData)) { return false; }
		
		return true;
	}

    static string defaultName() {
        return "plugin load";
    }

    //  Config file
    protected string configDataFile = CONFIG ~ "plugins.d";

    int execute(Arguments commandArguments, ConsoleIo aConsoleIo) {
        auto plugin = to!string(commandArguments.getArgument("plugin"));
        auto options = [];
        if (commandArguments.getOption("only-debug")) {
            options["onlyDebug"] = true;
        }
        if (commandArguments.getOption("only-cli")) {
            options["onlyCli"] = true;
        }
        if (commandArguments.getOption("optional")) {
            options["optional"] = true;
        }
        foreach ($hook; IPlugin.VALID_HOOKS) {
            if (commandArguments.getOption("no-" ~ hook)) {
                options[$hook] = false;
            }
        }
        try {
        Plugin. getCollection().findPath($plugin);
        } catch (MissingPluginException anException) {
            /** @psalm-suppress InvalidArgument */
            if (isEmpty(options["optional"])) {
                aConsoleIo.writeErrorMessages(anException.getMessage());
                aConsoleIo.writeErrorMessages("Ensure you have the correct spelling and casing.");

                return CODE_ERROR;
            }
        }
        result = this.modifyConfigFile($plugin, options);
        if (result == CODE_ERROR) {
            aConsoleIo.writeErrorMessages("Failed to update `CONFIG/plugins.d`");
        }
        aConsoleIo.success("Plugin added successfully to `CONFIG/plugins.d`");

        return result;
    }

    // Modify the plugins config file.
    protected int modifyConfigFile(string pluginName, IData[string] options = null) {
        // phpcs:ignore
        configData = @include this.configFile;
        configData = !configData.isArray ? Json.empty;
    } else {
        configData = Hash.normalize(configData);
    }

    configuration.getData(pluginName] = options;
    auto array = class_exists(VarExporter.class)
        ? VarExporter.export(configData, VarExporter.TRAILING_COMMA_IN_ARRAY) 
        : var_export(configData, true);

    contents = "" ~ "\n\n" ~ "return " ~ array ~ ";" ~ "\n";

    return file_put_contents(this.configFile, contents)
        ? CODE_SUCCESS
        : CODE_ERROR;
}

ConsoleOptionParser buildOptionParser(ConsoleOptionParser aParser) {
    with (aParser) {
        description([
            "Command for loading plugins.",
        ]); 
        addArgument("plugin", [
            "help": "Name of the plugin to load. Must be in CamelCase format. Example: cake plugin load Example",
            "required": true,
        ]); 
        addOption("only-debug", [
            "boolean": true,
            "help": "Load the plugin only when `debug` is enabled.",
        ]); 
        addOption("only-cli", [
            "boolean": true,
            "help": "Load the plugin only for CLI.",
        ]); 
        addOption("optional", [
            "boolean": true,
            "help": "Do not throw an error if the plugin is not available.",
        ]); 
        addOption("no-bootstrap", [
            "boolean": true,
            "help": "Do not run the `bootstrap()` hook.",
        ]); 
        addOption("no-console", [
            "boolean": true,
            "help": "Do not run the `console()` hook.",
        ]); addOption("no-middleware", [
            "boolean": true,
            "help": "Do not run the `middleware()` hook..",
        ]); 
        addOption("no-routes", [
            "boolean": true,
            "help": "Do not run the `routes()` hook.",
        ]);
        addOption("no-services", [
            "boolean": true,
            "help": "Do not run the `services()` hook.",
        ]);

    return aParser;
}
}
