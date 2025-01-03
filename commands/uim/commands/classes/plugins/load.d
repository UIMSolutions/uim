/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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

    override ulong execute(Json[string] arguments, IConsole aConsole = null) {
        return super.execute(arguments, consoleIo);
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
            .each!(hook => options.set(hook, false));

        try {
            Plugin.getCollection().findPath(plugin);
        } catch (MissingPluginException anException) {
            if (options.isEmpty("optional")) {
                consoleIo.writeErrorMessages(anException.message());
                consoleIo.writeErrorMessages("Ensure you have the correct spelling and casing.");

                return CODE_ERROR;
            }
        }
        result = this.modifyConfigFile(plugin, options);
        if (result == CODE_ERROR) {
            consoleIo.writeErrorMessages("Failed to update `CONFIG/plugins.d`");
        }
        consoleIo.success("Plugin added successfully to `CONFIG/plugins.d`");

        return result;
    }

    // Modify the plugins config file.
    protected int modifyConfigFile(string pluginName, Json[string] options = null) {

        /*
        configData = @include _configFile;
        configData = !configData.isArray ? Json.empty;
    }
 */
        /* configuration.set(pluginName, options);
    auto Json[string] = class_hasKey(VarExporter.classname)
        ? VarExporter.export_(configData, VarExporter.TRAILING_COMMA_IN_ARRAY) 
        : var_export_(configData, true);

    contents = "\n\n" ~ "return " ~ Json[string] ~ ";" ~ "\n";

    return file_put_contents(_configFile, contents)
        ? CODE_SUCCESS : CODE_ERROR; */
        return 0;
    }

    DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate) {
        with (parserToUpdate) {
            description("Command for loading plugins.");
            addArgument("plugin", createMap!(string, Json)
                    .set("help", "Name of the plugin to load. Must be in CamelCase format. Example: uim plugin load Example")
                    .set("required", true)
            );
            addOption("only-debug", createMap!(string, Json)
                    .set("boolean", true)
                    .set("help", "Load the plugin only when `debug` is enabled.")
            );
            addOption("only-cli", createMap!(string, Json)
                    .set("boolean", true)
                    .set("help", "Load the plugin only for CLI.")
            );
            addOption("optional", createMap!(string, Json)
                    .set("boolean", true)
                    .set("help", "Do not throw an error if the plugin is not available.")
            );
            addOption("no-bootstrap", createMap!(string, Json)
                    .set("boolean", true)
                    .set("help", "Do not run the `bootstrap()` hook.")
            );
            addOption("no-console", createMap!(string, Json)
                    .set("boolean", true)
                    .set("help", "Do not run the `console()` hook.")
            );
            addOption("no-middleware", createMap!(string, Json)
                    .set("boolean", true)
                    .set("help", "Do not run the `middleware()` hook..")
            );
            addOption("no-routes", createMap!(string, Json)
                    .set("boolean", true)
                    .set("help", "Do not run the `routes()` hook.")
            );
            addOption("no-services", createMap!(string, Json)
                    .set("boolean", true)
                    .set("help", "Do not run the `services()` hook.")
            );

            return aParser;
        }
    }
}

    mixin(CommandCalls!("PluginLoad"));
