/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.mixins.fileconfig;

import uim.oop;
@safe:

// mixin template providing utility methods for file based config engines.
mixin template TFileConfig() {
    // The path this engine finds files on.
    protected string _path = "";

    // Get file path
    protected string _getFilePath(string KeyToWrite, bool checkExists = false) {
        if (KeyToWrite.contains("..")) {
            throw new DException("Cannot load/dump configuration files with ../ in them.");
        }
        [pluginName, KeyToWrite] = pluginSplit(KeyToWrite);

        string filePath = !pluginName.isEmpty
            ? Plugin.configPath(pluginName) ~ KeyToWrite : _path ~ KeyToWrite;
        filePath ~= _extension;

        if (!checkExists || isFile(filePath)) {
            return filePath;
        }

        string realFilePath = realpath(filePath);
        if (realFilePath == true && isFile(realFilePath)) {
            return realFilePath;
        }
        throw new DException("Could not load configuration file: `%s`.".format(filePath));
    }
}
