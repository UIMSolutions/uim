module uim.commands.mixins.assets;

import uim.commands;

@safe:

/* * template for symlinking / copying plugin assets to app"s webroot.
 * @internal
 */
mixin template TPluginAssets() {
    protected Json[string] arguments;

    /*
    // Console IO
    protected IConsoleIo aConsoleIo;

    /**
     * Get list of plugins to process. Plugins without a webroot directory are skipped.
     * Params:
     * If null all plugins will be processed.
     */
    protected Json[string] _list(string pluginName = null) {
        auto pluginsList = pluginName.isNull
            ? Plugin.loaded()
            : [pluginName];
        
        Json[string] plugins = null;
        pluginsList.each!((plugin) {
            auto somePath = Plugin.path(plugin) ~ "webroot";
            if (!isDir(somePath)) {
                _io.verbose("", 1);
                _io.verbose("Skipping plugin %s. It does not have webroot folder.".format(plugin), 2);
                continue;
            }
            string link = Inflector.underscore(plugin);
            auto wwwRoot = configuration.get("App.wwwRoot");
            string dir = wwwRoot;
            auto namespaced = false;
            if (link.contains("/")) {
                namespaced = true;
                string[] someParts = link.split("/");
                link = array_pop(someParts);
                dir = wwwRoot ~ someParts.join(DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR;
            }
            plugins.set(plugin, [
                "srcPath": Plugin.path(plugin) ~ "webroot",
                "destDir": dir,
                "link": link,
                "namespaced": namespaced,
            ]);
        });

        return plugins;
    }
    
    // Process plugins
    protected void _process(Json[string] pluginsToProcess, bool copyMode = false, bool overwriteExisting = false) {
        foreach (plugin: configData; pluginsToProcess) {
            _io.writeln();
            _io.writeln("For plugin: " ~ plugin);
            _io.hr();

            if (
                configuration.hasKey("namespaced") && !isDir(configuration.get("destDir")) &&
                !_createDirectory(configuration.get("destDir"))
           ) {
                continue;
            }
            
            string dest = configuration.getString("destDir") ~ configuration.getString("link");
            if (filehasKey(dest)) {
                if (overwriteExisting && !_remove(configData)) {
                    continue;
                } else if (!overwriteExisting) {
                    _io.verbose(
                        dest ~ " already exists",
                        1
                   );

                    continue;
                }
            }
            if (!copyMode) {
                result = _createSymlink(
                    configuration.get("srcPath"),
                    dest
               );
                if (result) {
                    continue;
                }
            }
           _copyDirectory(
                configuration.get("srcPath"),
                dest
           );
        }
        _io.writeln();
        _io.writeln("Done");
    }
    
    /**
     * Remove folder/symlink.
     *
     * configData - Plugin config.
     */
    protected bool _remove(Json[string] configData = null) {
        if (configuration.hasKey("namespaced") && !isDir(configuration.get("destDir"))) {
            _io.verbose(
                configuration.getString("destDir") ~ configuration.getString("link") ~ " does not exist",
                1
           );

            return false;
        }
        
        string destDirLink = configuration.getString("destDir") ~ configuration.getString("link");
        if (!filehasKey(destDirLink)) {
            _io.verbose(
                destDirLink ~ " does not exist",
                1
           );

            return false;
        }
        /* if (isLink(dest)) {
            
            success = DIRECTORY_SEPARATOR == "\\" ? @rmdir(dest): @unlink(dest);
            if (success) {
                _io.writeln("Unlinked " ~ dest);

                return true;
            } else {
                _io.writeErrorMessages("Failed to unlink  " ~ dest);

                return false;
            }
        } */
        
        auto fs = new DFilesystem();
        if (fs.deleteDir(dest)) {
            _io.writeln("Deleted " ~ dest);

            return true;
        } else {
            _io.writeErrorMessages("Failed to delete " ~ dest);

            return false;
        }
    }
    
    // Create directory
    protected bool _createDirectory(string directoryName) {
        auto old = umask(0);
        // auto result = @mkdir(directoryName, 0755, true);
        umask(old);

        /* if (result) {
            _io.writeln("Created directory " ~ directoryName);

            return true;
        } */
        _io.writeErrorMessages("Failed creating directory " ~ directoryName);

        return false;
    }
    
    // Create symlink
    protected bool _createSymlink(string targetDirectory, string linkName) {
        // auto result = @symlink(targetDirectory, linkName);

        /* if (result) {
            _io.writeln("Created symlink " ~ linkName);
            return true;
        } */
        return false;
    }
    
    // Copy directory
    protected bool _copyDirectory(string sourceDir, string destinationDir) {
        auto fs = new DFilesystem();
        if (fs.copyDir(sourceDir, destinationDir)) {
            _io.writeln("Copied assets to directory " ~ destinationDir);

            return true;
        }
        _io.writeErrorMessages("Error copying assets to directory " ~ destinationDir);

        return false;
    }
}
