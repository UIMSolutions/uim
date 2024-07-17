module uim.commands.classes.commands.plugins.assets.remove;

import uim.commands;

@safe:

// Command for removing plugin assets from app`s webroot.
class DPluginAssetsRemoveCommand : DCommand {
    mixin(CommandThis!("PluginAssetsRemove"));
    mixin TPluginAssets;

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    static string defaultName() {
        return "plugin-assets-remove";
    }

    
    // Remove plugin assets from app`s webroot.
    override ulong execute(Json[string] arguments, IConsoleIo consoleIo) {
        _io = consoleIo;
        _args = arguments;

        auto name = arguments.getArgument("name");
        plugins = _list(name);

        plugins.byKeyValue
            .each!((pluginConfigData) {
                _io.writeln();
                _io.writeln("For plugin: " ~ pluginConfigData.key);
                _io.hr();

                _removeByKey((pluginConfigData.value);
            });
        _io.writeln();
        _io.writeln("Done");

        return CODE_SUCCESS;
    }

    // Get the option parser.
    DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate) {
        parserToUpdate.description("Remove plugin assets from app`s webroot.");

        parserToUpdate.addArgument("name", [
                "help": Json("A specific plugin you want to remove."),
                "required": false.toJson
            ]);

        return parserToUpdate;
    } 
}
mixin(CommandCalls!("PluginAssetsRemove"));

unittest {
}
