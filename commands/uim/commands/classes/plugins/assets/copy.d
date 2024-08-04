module uim.commands.classes.commands.plugins.assets.copy;

import uim.commands;

@safe:

// Command for copying plugin assets to app`s webroot.
class DPluginAssetsCopyCommand : DCommand {
    mixin(CommandThis!("PluginAssetsCopy"));

    mixin TPluginAssets;

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    static string defaultName() {
        return "plugin-assets-copy";
    }

    override size_t execute(Json[string] arguments, IConsoleIo consoleIo) {
        return super.execute(arguments, consoleIo);
    }

    // Get the option parser.
    /* TODO override */  DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate){
        // TODO parserToUpdate.description("Copy plugin assets to app`s webroot.");

        /* 
        parserToUpdate.addArgument("name", createMap!(string, Json)
            .set("help", "A specific plugin you want to copy assets for.")
            .set("required", false)
        );
        
        parserToUpdate.addOption("overwrite", createMap!(string, Json)
            .set("help", "Overwrite existing symlink / folder / files.")
            .set("default", false)
            .set("boolean", true)
        ); */

        return parserToUpdate;
    } 

    /**
     * Copying plugin assets to app`s webroot. For vendor namespaced plugin,
     * parent folder for vendor name are created if required.
     */
    size_t execute(Json[string] arguments, IConsoleIo consoleIo) {
        _io = consoleIo;
        _args = arguments;

        auto name = arguments.getString("name");
        auto shouldOverwrite = arguments.getBoolean("overwrite");
       _process(_list(name), true, shouldOverwrite);

        return CODE_SUCCESS;
    } 
}

mixin(CommandCalls!("PluginAssetsCopy"));
