/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.plugins.unload;

import uim.commands;

@safe:

// Command for unloading plugins.
class DPluginUnloadCommand : DCommand {
    mixin(CommandThis!("PluginUnload"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    // TODO protected string configDataFile = CONFIG ~ "plugins.d";

    static string defaultName() {
        return "plugin-unload";
    }

    override bool execute(Json[string] arguments, IConsole console = null) {
        string pluginName = arguments.getString("plugin");

        /* auto modificationResult = modifyConfigFile(pluginName);
        if (modificationResult.isNull) {
            console.success("Plugin removed from `CONFIG/plugins.d`");

            return true;
        }
        console.writeErrorMessages(modificationResult); */

        return false;
    }

    //  Modify the plugins config file.
    protected string modifyConfigFile(string pluginName) {
        /* auto configData = @include _configFile;
        if (!configuration.isArray) {
            return "`CONFIG/plugins.d` not found or does not return an array";
        }
        if (!hasKey(pluginName, configData)) {
            return "plugin-`%s` could not be found".format(pluginName);
        }
        configuration.removeKey(pluginName);

        string exported = class_hasKey(VarExporter.classname)
            ? VarExporter.export_(configData)
            : var_export_(configData, true);
        contents = "" ~ "\n" ~ "return " ~ exported ~ ";";

        return !file_put_contents(_configFile, contents)
            ? "Failed to update `CONFIG/plugins.d`"
            : null; */
        return null; 
    }

    // Get the option parser.
    DConsoleOptionParser buildOptionParser(DConsoleOptionParser parsertoUpdate) {
        parsertoUpdate.description("Command for unloading plugins.");
        
        Json[string] map;
        map.set("help", "Name of the plugin to unload.");
        map.set("required", true);
        parsertoUpdate.addArgument("plugin", map);

        return parsertoUpdate;
    }
}

mixin(CommandCalls!("PluginUnload"));
