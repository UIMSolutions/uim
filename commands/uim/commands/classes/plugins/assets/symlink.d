/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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

    /* DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate) {
        with (parserToUpdate) {
            description("symlink (copy as fallback) plugin assets to app`s webroot.");

            addArgument("name", MapHelper.create!(string, Json)
                    .set("help", "A specific plugin you want to symlink assets for.")
                    .set("required", false));

            addOption("overwrite", MapHelper.create!(string, Json)
                    .set("help", "Overwrite existing symlink / folder / files.")
                    .set("default", false)
                    .set("boolean", true));
        }
        return parserToUpdate;
    } */

    /**
     * Attempt to symlink plugin assets to app`s webroot. If symlinking fails it
     * fallbacks to copying the assets. For vendor namespaced plugin, parent folder
     * for vendor name are created if required.
     */
    override bool execute(Json[string] arguments, IConsole console = null) {
/*         _io = aConsole;
        _args = commandArguments;

        auto name = commandArguments.getArgument("name");
        auto overwrite = arguments.getBoolean("overwrite");
        _process(_list(name), false, overwrite); */

        return true;
    }
}

mixin(CommandCalls!("PluginAssetsSymlink"));
