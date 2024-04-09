module uim.commands.classes.commands.plugins.assets.symlink;

import uim.commands;

@safe:

// Command for symlinking / copying plugin assets to app`s webroot.
class DPluginAssetsSymlinkCommand : DCommand {
    mixin(CommandThis!("PluginAssetsSymlink"));

    mixin TPluginAssets;

    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    static string defaultName() {
        return "plugin-assets-symlink";
    }

    /**
     * Attempt to symlink plugin assets to app`s webroot. If symlinking fails it
     * fallbacks to copying the assets. For vendor namespaced plugin, parent folder
     * for vendor name are created if required.
     * /
  int execute(IData[string] arguments, IConsoleIo aConsoleIo) {
        this.io = aConsoleIo;
        this.args = commandArguments;

        auto name = commandArguments.getArgument("name");
       auto overwrite = (bool)commandArguments.getOption("overwrite");
       _process(_list(name), false, overwrite);

        return CODE_SUCCESS;
    }

    DConsoleOptionParser buildOptionParser buildOptionParser(DConsoleOptionParser buildOptionParser parserToUpdate) {
        parserToUpdate.description([
            "symlink (copy as fallback) plugin assets to app\`s webroot.",
        ]).addArgument("name", [
            "help": "A specific plugin you want to symlink assets for.",
            "required": BooleanData(false),
        ]).addOption("overwrite", [
            "help": "Overwrite existing symlink / folder / files.",
            "default": BooleanData(false),
            "boolean": BooleanData(true),
        ]);

        return parserToUpdate;
    } */
}

mixin(CommandCalls!("PluginAssetsSymlink"));
