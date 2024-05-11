module uim.commands.classes.commands.plugins.assets.symlink;

import uim.commands;

@safe:

// Command for symlinking / copying plugin assets to app`s webroot.
class DPluginAssetsSymlinkCommand : DCommand {
    mixin(CommandThis!("PluginAssetsSymlink"));

    mixin TPluginAssets;

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    static string defaultName() {
        return "plugin-assets-symlink";
    }

    override int execute(Json[string] arguments, IConsoleIo aConsoleIo) {
        return super.execute(arguments, aConsoleIo);
    }

    DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate) {
        // TODO parserToUpdate.description("symlink (copy as fallback) plugin assets to app`s webroot.");
        
        /* 
        parserToUpdate.addArgument("name", [
            "help": "A specific plugin you want to symlink assets for.",
            "required": false.toJson,
        ]); */
        
        /*  TODO parserToUpdate.addOption("overwrite", [
            "help": "Overwrite existing symlink / folder / files.",
            "default": false.toJson,
            "boolean": true.toJson,
        ]); */

        return parserToUpdate;
    }

    /**
     * Attempt to symlink plugin assets to app`s webroot. If symlinking fails it
     * fallbacks to copying the assets. For vendor namespaced plugin, parent folder
     * for vendor name are created if required.
     */
    int execute(Json[string] arguments, IConsoleIo aConsoleIo) {
        this.io = aConsoleIo;
        this.args = commandArguments;

        auto name = commandArguments.getArgument("name");
       auto overwrite = (bool)commandArguments.getOption("overwrite");
       _process(_list(name), false, overwrite);

        return CODE_SUCCESS;
    }

 */
}

mixin(CommandCalls!("PluginAssetsSymlink"));
