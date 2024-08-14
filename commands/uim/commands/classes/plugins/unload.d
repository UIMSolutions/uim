module uim.commands.classes.commands.plugins.unload;

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

    override ulong execute(Json[string] arguments, IConsoleIo consoleIo) {
        return super.execute(arguments, consoleIo);
    }

    ulong execute(Json[string] arguments, IConsoleIo consoleIo) {
        string pluginName = arguments.getString("plugin");

        auto modificationResult = modifyConfigFile(pluginName);
        if (modificationResult.isNull) {
            consoleIo.success("Plugin removed from `CONFIG/plugins.d`");

            return CODE_SUCCESS;
        }
        consoleIo.writeErrorMessages(modificationResult);

        return CODE_ERROR;
    }

    //  Modify the plugins config file.
    protected string modifyConfigFile(string pluginName) {
        auto configData = @include _configFile;
        if (!configData.isArray) {
            return "`CONFIG/plugins.d` not found or does not return an array";
        }
        configData = Hash.normalize(configData);
        if (!hasKey(pluginName, configData)) {
            return "plugin-`%s` could not be found".format(pluginName);
        }
        configData.remove(pluginName);

        string exported = class_hasKey(VarExporter.classname)
            ? VarExporter.export_(configData)
            : var_export_(configData, true);
        contents = "" ~ "\n" ~ "return " ~ exported ~ ";";

        return !file_put_contents(_configFile, contents)
            ? "Failed to update `CONFIG/plugins.d`"
            : null;
    }

    // Get the option parser.
    DConsoleOptionParser buildOptionParser(DConsoleOptionParser parsertoUpdate) {
        parsertoUpdate.description("Command for unloading plugins.");
        
        parsertoUpdate.addArgument("plugin", createMap!(string, Json)()
                .set("help", "Name of the plugin to unload.")
                .set("required", true)
            );

        return parsertoUpdate;
    }
}

mixin(CommandCalls!("PluginUnload"));
