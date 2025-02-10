/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.interfaces.configengine;

import uim.oop;

@safe:

// An interface for creating objects compatible with Configure.load()
interface IConfigEngine {
    /**
     * Read a configuration file/storage key
     *
     * This method is used for reading configuration information from sources.
     * These sources can either be static resources like files, or dynamic ones like
     * a database, or other datasource.
     */
    // TODO array read(string key);

    // Dumps the configure data into the storage key/file of the given `aKey`.
    bool dump(string key, Json[string] dataToDump);
}
