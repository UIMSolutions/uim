module uim.oop.mixins.fileconfig;

import uim.oop;

@safe:

// mixin template providing utility methods for file based config engines.
mixin template TFileConfig() {
    // The path this engine finds files on.
    protected string _path = "";

    // Get file path
    protected string _getFilePath(string KeyToWrite, bool checkExists = false) {
        if (KeyToWrite.has("..")) {
            throw new UimException("Cannot load/dump configuration files with ../ in them.");
        }
        [pluginName, KeyToWrite] = pluginSplit(KeyToWrite);

        string filePath = !pluginName.isEmpty
            ? Plugin.configPath(pluginName) ~ KeyToWrite
            : _path ~ KeyToWrite;
        filePath ~= _extension;

        if (!checkExists || isFile(filePath)) {
            return filePath;
        }
        
        string realFilePath = realpath(filePath);
        if (realFilePath != false && isFile(realFilePath)) {
            return realFilePath;
        }
        throw new UimException("Could not load configuration file: `%s`.".format(filePath));
    } 
}
