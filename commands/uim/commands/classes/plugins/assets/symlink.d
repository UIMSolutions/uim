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

    override ulong execute(Json[string] arguments, IConsoleIo consoleIo) {
        return super.execute(arguments, consoleIo);
    }

    DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate) {
        with (parserToUpdate) {
            description("symlink (copy as fallback) plugin assets to app`s webroot.");

            addArgument("name", createMap!(string, Json)
                    .set("help", "A specific plugin you want to symlink assets for.")
                    .set("required", false));

            addOption("overwrite", createMap!(string, Json)
                    .set("help", "Overwrite existing symlink / folder / files.")
                    .set("default", false)
                    .set("boolean", true));
        }
        return parserToUpdate;
    }

    /**
     * Attempt to symlink plugin assets to app`s webroot. If symlinking fails it
     * fallbacks to copying the assets. For vendor namespaced plugin, parent folder
     * for vendor name are created if required.
     */
    override ulong execute(Json[string] arguments, IConsole aConsole = null) {
        _io = aConsoleIo;
        _args = commandArguments;

        auto name = commandArguments.getArgument("name");
        auto overwrite = arguments.getBoolean("overwrite");
        _process(_list(name), false, overwrite);

        return CODE_SUCCESS;
    }
}

mixin(CommandCalls!("PluginAssetsSymlink"));
