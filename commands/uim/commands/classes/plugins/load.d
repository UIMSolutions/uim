module uim.commands.classes.commands.plugins.load;

import uim.commands;

@safe:

// Command for loading plugins.
class DPluginLoadCommand : DCommand {
    mixin(CommandThis!("PluginLoad"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        // TODO configDataFile = CONFIG ~ "plugins.d";

        return true;
    }

    static string defaultName() {
        return "plugin-load";
    }

    //  Config file
    protected string _configDataFile;

    override override ulong execute(Json[string] arguments, IConsole aConsole = null) {
        return super.execute(arguments, aConsoleIo);
    }

    override ulong execute(Json[string] arguments, IConsole aConsole = null) {
        auto plugin = arguments.getString("plugin");
        auto options = null;
        if (arguments.hasKey("only-debug")) {
            options.set("onlyDebug", true);
        }
        if (arguments.hasKey("only-cli")) {
            options.set("onlyCli", true);
        }
        if (arguments.hasKey("optional")) {
            options.set("optional", true);
        }
        IPlugin.VALID_HOOKS
            .filter!(hook => arguments.hasKey("no-" ~ hook))
            .each!(hook => options[hook] = false);

        try {
            Plugin.getCollection().findPath(plugin);
        } catch (MissingPluginException anException) {
            /** @psalm-suppress InvalidArgument */
            if (options.isEmpty("optional")) {
                aConsoleIo.writeErrorMessages(anException.getMessage());
                aConsoleIo.writeErrorMessages("Ensure you have the correct spelling and casing.");

                return CODE_ERROR;
            }
        }
        result = this.modifyConfigFile(plugin, options);
        if (result == CODE_ERROR) {
            aConsoleIo.writeErrorMessages("Failed to update `CONFIG/plugins.d`");
        }
        aConsoleIo.success("Plugin added successfully to `CONFIG/plugins.d`");

        return result;
    }

    // Modify the plugins config file.
/*     protected int modifyConfigFile(string pluginName, Json[string] options = null) {

        configData = @include this.configFile;
        configData = !configData.isArray ? Json.empty;
    } else {
        configData = Hash.normalize(configData);
    }
 */
    /* configuration.set(pluginName, options);
    auto Json[string] = class_exists(VarExporter.classname)
        ? VarExporter.export_(configData, VarExporter.TRAILING_COMMA_IN_ARRAY) 
        : var_export_(configData, true);

    contents = "\n\n" ~ "return " ~ Json[string] ~ ";" ~ "\n";

    return file_put_contents(this.configFile, contents)
        ? CODE_SUCCESS : CODE_ERROR; */
    return 0;
}

DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate) {
    with (parserToUpdate) {
        description("Command for loading plugins.");
        addArgument("plugin", [
                "help": "Name of the plugin to load. Must be in CamelCase format. Example: uim plugin load Example",
                "required": true.toJson,
            ]);
        addOption("only-debug", [
                "boolean": true.toJson,
                "help": "Load the plugin only when `debug` is enabled.",
            ]);
        addOption("only-cli", [
                "boolean": true.toJson,
                "help": "Load the plugin only for CLI.",
            ]);
        addOption("optional", [
                "boolean": true.toJson,
                "help": "Do not throw an error if the plugin is not available.",
            ]);
        addOption("no-bootstrap", [
                "boolean": true.toJson,
                "help": "Do not run the `bootstrap()` hook.",
            ]);
        addOption("no-console", [
                "boolean": true.toJson,
                "help": "Do not run the `console()` hook.",
            ]);
        addOption("no-middleware", [
                "boolean": true.toJson,
                "help": "Do not run the `middleware()` hook..",
            ]);
        addOption("no-routes", [
                "boolean": true.toJson,
                "help": "Do not run the `routes()` hook.",
            ]);
        addOption("no-services", [
                "boolean": true.toJson,
                "help": "Do not run the `services()` hook.",
            ]);

        return aParser;
    }
}

mixin(CommandCalls!("PluginLoad"));
