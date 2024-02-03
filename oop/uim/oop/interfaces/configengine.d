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
    array read(string key);

    /**
     * Dumps the configure data into the storage key/file of the given `aKey`.
     * Params:
     * @param array data The data to dump.
     */
    bool dump(string key, array data);
}
