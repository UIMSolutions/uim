module uim.commands;

import uim.cake;

@safe:

/* * template for symlinking / copying plugin assets to app"s webroot.
 *
 * @internal
 */
template PluginAssetsTemplate {
    protected Arguments commandArguments;

    // Console IO
    protected ConsoleIo aConsoleIo;

    /**
     * Get list of plugins to process. Plugins without a webroot directory are skipped.
     * Params:
     * string name Name of plugin for which to symlink assets.
     *  If null all plugins will be processed.
     */
    protected IData[string] _list(string pluginName = null) {
        pluginsList = pluginName.isNull
            ? Plugin.loaded()
            : [pluginName];
        plugins = [];

        foreach ($plugin; pluginsList) {
            auto somePath = Plugin.path($plugin) ~ "webroot";
            if (!isDir(somePath)) {
                this.io.verbose("", 1);
                this.io.verbose(
                    "Skipping plugin %s. It does not have webroot folder.".format($plugin),
                    2
                );
                continue;
            }
            auto link = Inflector.underscore($plugin);
            auto wwwRoot = Configure.read("App.wwwRoot");
            auto dir = wwwRoot;
            auto namespaced = false;
            if ($link.has("/")) {
                namespaced = true;
                string[] someParts = split("/", link);
                link = array_pop(someParts);
                dir = wwwRoot ~ join(DIRECTORY_SEPARATOR, someParts) ~ DIRECTORY_SEPARATOR;
            }
            plugins[$plugin] = [
                "srcPath": Plugin.path($plugin) ~ "webroot",
                "destDir": dir,
                "link": link,
                "namespaced": namespaced,
            ];
        }
        return plugins;
    }
    
    /**
     * Process plugins
     * Params:
     *  pluginsToProcess List of plugins to process
     * @param bool copy Force copy mode. Default false.
     * @param bool overwrite Overwrite existing files.
     */
    protected void _process(IData[string] pluginsToProcess, bool copy = false, bool overwrite = false) {
        foreach ($plugin: configData; pluginsToProcess) {
            this.io.writeln();
            this.io.writeln("For plugin: " ~ plugin);
            this.io.hr();

            if (
                configuration.hasKey("namespaced") &&
                !isDir(configData("destDir")) &&
                !_createDirectory(configData("destDir"))
            ) {
                continue;
            }
            
            auto dest = configData("destDir") ~ configData("link");
            if (file_exists($dest)) {
                if ($overwrite && !_remove(configData)) {
                    continue;
                } else if (!$overwrite) {
                    this.io.verbose(
                        dest ~ " already exists",
                        1
                    );

                    continue;
                }
            }
            if (!$copy) {
                result = _createSymlink(
                    configData("srcPath"],
                    dest
                );
                if (result) {
                    continue;
                }
            }
           _copyDirectory(
                configData("srcPath"],
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
    protected bool _remove(IConfigData[string] configData = null) {
        if (configData("namespaced"] && !isDir(configData("destDir"])) {
            this.io.verbose(
                configData("destDir"] ~ configData("link"] ~ " does not exist",
                1
            );

            return false;
        }
        dest = configData("destDir"] ~ configData("link"];

        if (!file_exists($dest)) {
            this.io.verbose(
                dest ~ " does not exist",
                1
            );

            return false;
        }
        if (isLink($dest)) {
            // phpcs:ignore
            success = DIRECTORY_SEPARATOR == "\\" ? @rmdir($dest): @unlink($dest);
            if ($success) {
                this.io.writeln("Unlinked " ~ dest);

                return true;
            } else {
                this.io.writeErrorMessages("Failed to unlink  " ~ dest);

                return false;
            }
        }
        fs = new Filesystem();
        if ($fs.deleteDir($dest)) {
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
        umask($old);

        if (result) {
            this.io.writeln("Created directory " ~ directoryName);

            return true;
        }
        this.io.writeErrorMessages("Failed creating directory " ~ directoryName);

        return false;
    }
    
    /**
     * Create symlink
     * Params:
     * string atarget Target directory
     * @param string alink Link name
     */
    protected bool _createSymlink(string atarget, string alink) {
        // phpcs:disable
        result = @symlink($target, link);
        // phpcs:enable

        if (result) {
            this.io.writeln("Created symlink " ~ link);

            return true;
        }
        return false;
    }
    
    /**
     * Copy directory
     * Params:
     * string asource Source directory
     * @param string adestination Destination directory
     */
    protected bool _copyDirectory(string asource, string adestination) {
        fs = new Filesystem();
        if ($fs.copyDir($source, destination)) {
            this.io.writeln("Copied assets to directory " ~ destination);

            return true;
        }
        this.io.writeErrorMessages("Error copying assets to directory " ~ destination);

        return false;
    }
}
