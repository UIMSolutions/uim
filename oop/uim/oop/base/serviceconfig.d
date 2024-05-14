module uim.oop.base.serviceconfig;

import uim.oop;

@safe:

/* * Read-only wrapper for configuration data
 *
 * Intended for use with {@link \UIM\Core\Container} as
 * a typehintable way for services to have application
 * configuration injected as arrays cannot be typehinted.
 */
class DServiceConfig {
    /**
     * Read a configuration key
     * Params:
     * string aPath The path to read.
     * @param IData defaultValue The default value to use if somePath does not exist.
     */
    IData get(string aPath, IData defaultData = null) {
        return configuration.get(somePath, defaultData);
    }
    
    //  Check if somePath exists and has a non-null value.
    bool has(string pathToCheck) {
        return Configure.check(pathToCheck);
    } */
}
