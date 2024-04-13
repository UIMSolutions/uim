module uim.commands.classes.commands.plugins.assets.copy;

import uim.commands;

@safe:

// Command for copying plugin assets to app`s webroot.
class DPluginAssetsCopyCommand : DCommand {
    mixin(CommandThis!("PluginAssetsCopy"));

    mixin TPluginAssets;

    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    static string defaultName() {
        return "plugin-assets-copy";
    }

    override int execute(IData[string] arguments, IConsoleIo aConsoleIo) {
        return super.execute(arguments, aConsoleIo);
    }

    // Get the option parser.
    /*  TODO override */  DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate){
        // TODO parserToUpdate.description("Copy plugin assets to app`s webroot.");

        /* 
        parserToUpdate.addArgument("name", [
            "help": "A specific plugin you want to copy assets for.",
            "required": BooleanData(false),
        ]);
        
        parserToUpdate.addOption("overwrite", [
            "help": "Overwrite existing symlink / folder / files.",
            "default": BooleanData(false),
            "boolean": BooleanData(true),
        ]); */

        return parserToUpdate;
    } 

    /**
     * Copying plugin assets to app`s webroot. For vendor namespaced plugin,
     * parent folder for vendor name are created if required.
     * /
    int execute(IData[string] arguments, IConsoleIo aConsoleIo) {
        this.io = aConsoleIo;
        this.args = commandArguments;

        auto name = commandArguments.getArgument("name");
        auto shouldOverwrite = (bool)commandArguments.getOption("overwrite");
       _process(_list(name), true, shouldOverwrite);

        return CODE_SUCCESS;
    } */ 
}

mixin(CommandCalls!("PluginAssetsCopy"));
