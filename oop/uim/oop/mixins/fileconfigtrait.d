module oop.uim.oop.mixins.fileconfigtrait;

import uim.oop;

@safe:

// mixin template providing utility methods for file based config engines.
mixin template FileConfigTemplate() {
    // The path this engine finds files on.
    protected string _path = "";

    /**
     * Get file path
     * Params:
     * string aKey The identifier to write to. If the key has a ~ it will be treated as a plugin prefix.
     * @param bool checkExists Whether to check if file exists. Defaults to false.
     * /
    protected string _getFilePath(string aKey, bool checkExists = false) {
        if (aKey.has("..")) {
            throw new UimException("Cannot load/dump configuration files with ../ in them.");
        }
        [pluginName, aKey] = pluginSplit(aKey);

        string filePath = !pluginName.isEmpty
            ? Plugin.configPath(pluginName) ~ aKey
            : _path ~ aKey;
        filePath ~= _extension;

        if (!checkExists || isFile(filePath)) {
            return filePath;
        }
        
        string realFilePath = realpath(filePath);
        if (realFilePath != false && isFile(realFilePath)) {
            return realFilePath;
        }
        throw new UimException("Could not load configuration file: `%s`.".format(filePath));
    } */
}
