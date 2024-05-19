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
                this.io.verbose("", 1);
                this.io.verbose("Skipping plugin %s. It does not have webroot folder.".format(plugin), 2);
                continue;
            }
            auto link = Inflector.underscore(plugin);
            auto wwwRoot = configuration.get("App.wwwRoot");
            auto dir = wwwRoot;
            auto namespaced = false;
            if (link.has("/")) {
                namespaced = true;
                string[] someParts = link.split("/");
                link = array_pop(someParts);
                dir = wwwRoot ~ join(DIRECTORY_SEPARATOR, someParts) ~ DIRECTORY_SEPARATOR;
            }
            plugins[plugin] = [
                "srcPath": Plugin.path(plugin) ~ "webroot",
                "destDir": dir,
                "link": link,
                "namespaced": namespaced,
            ];
        });

        return plugins;
    }
    
    // Process plugins
    protected void _process(Json[string] pluginsToProcess, bool copyMode = false, bool overwriteExisting = false) {
        foreach (plugin: configData; pluginsToProcess) {
            this.io.writeln();
            this.io.writeln("For plugin: " ~ plugin);
            this.io.hr();

            if (
                configuration.hasKey("namespaced") &&
                !isDir(configuration.data("destDir")) &&
                !_createDirectory(configuration.data("destDir"))
            ) {
                continue;
            }
            
            string dest = configuration.data("destDir") ~ configuration.data("link");
            if (fileExists(dest)) {
                if (overwriteExisting && !_remove(configData)) {
                    continue;
                } else if (!overwriteExisting) {
                    this.io.verbose(
                        dest ~ " already exists",
                        1
                    );

                    continue;
                }
            }
            if (!copyMode) {
                result = _createSymlink(
                    configuration.data("srcPath"],
                    dest
                );
                if (result) {
                    continue;
                }
            }
           _copyDirectory(
                configuration.data("srcPath"],
                dest
            );
        }
        this.io.writeln();
        this.io.writeln("Done");
    }
    
    /**
     * Remove folder/symlink.
     *
     * configData - Plugin config.
     */
    protected bool _remove(Json[string] configData = null) {
        if (configuration.data("namespaced"] && !isDir(configuration.data("destDir"])) {
            this.io.verbose(
                configuration.data("destDir"] ~ configuration.data("link"] ~ " does not exist",
                1
            );

            return false;
        }
        dest = configuration.data("destDir"] ~ configuration.data("link"];

        if (!fileExists(dest)) {
            this.io.verbose(
                dest ~ " does not exist",
                1
            );

            return false;
        }
        if (isLink(dest)) {
            
            success = DIRECTORY_SEPARATOR == "\\" ? @rmdir(dest): @unlink(dest);
            if (success) {
                this.io.writeln("Unlinked " ~ dest);

                return true;
            } else {
                this.io.writeErrorMessages("Failed to unlink  " ~ dest);

                return false;
            }
        }
        fs = new DFilesystem();
        if (fs.deleteDir(dest)) {
            this.io.writeln("Deleted " ~ dest);

            return true;
        } else {
            this.io.writeErrorMessages("Failed to delete " ~ dest);

            return false;
        }
    }
    
    // Create directory
    protected bool _createDirectory(string directoryName) {
        old = umask(0);
        result = @mkdir(directoryName, 0755, true);
        umask(old);

        if (result) {
            this.io.writeln("Created directory " ~ directoryName);

            return true;
        }
        this.io.writeErrorMessages("Failed creating directory " ~ directoryName);

        return false;
    }
    
    // Create symlink
    protected bool _createSymlink(string targetDirectory, string linkName) {
        auto result = @symlink(targetDirectory, linkName);

        if (result) {
            this.io.writeln("Created symlink " ~ linkName);
            return true;
        }
        return false;
    }
    
    // Copy directory
    protected bool _copyDirectory(string sourceDir, string destinationDir) {
        auto fs = new DFilesystem();
        if (fs.copyDir(sourceDir, destinationDir)) {
            this.io.writeln("Copied assets to directory " ~ destinationDir);

            return true;
        }
        this.io.writeErrorMessages("Error copying assets to directory " ~ destinationDir);

        return false;
    }
}
