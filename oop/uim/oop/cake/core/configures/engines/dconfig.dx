module source.uim.cake.core.configures.engines.dconfig;

import uim.cake;

@safe:

/**
 * PHP engine allows Configure to load configuration values from
 * files containing simple PHP arrays.
 *
 * Files compatible with PhpConfig should return an array that
 * contains all the configuration data contained in the file.
 *
 * An example configuration file would look like.
 *
 * ```
 * 
 * return [
 *    'debug": false,
 *    `security": [
 *        `salt": 'its-secret'
 *    ],
 *    'App": [
 *        'namespace": 'App'
 *    ]
 * ];
 * ```
 *
 * @see \UIM\Core\Configure.load() for how to load custom configuration files.
 */
class PhpConfig : IConfigEngine {
    mixin FileConfigTemplate();

    // File extension.
    protected string _extension = ".d";

    this(string pathToConfigFiles = null) {
       _path = pathToConfigFiles ?? CONFIG;
    }
    
    /**
     * Read a config file and return its contents.
     *
     * Files with `.` in the name will be treated as values in plugins. Instead of
     * reading from the initialized path, plugin keys will be located using Plugin.path().
     * Params:
     * string aKey The identifier to read from. If the key has a ~ it will be treated
     * as a plugin prefix.
     */
    array read(string aKey) {
        auto file = _getFilePath(aKey, true);

        result = include file;
        if (isArray(result)) {
            return result;
        }
        throw new UimException("Config file `%s` did not return an array".format(aKey ~ ".d."));
    }
    
    /**
     * Converts the provided someData into a string of PHP code that can
     * be used saved into a file and loaded later.
     * Params:
     * string aKey The identifier to write to. If the key has a ~ it will be treated
     * as a plugin prefix.
         */
    bool dump(string aKey, IData[] dataToDump) {
        string contents = "" ~ "\n" ~ "return " ~ var_export(dataToDump, true) ~ ";";

        string filename = _getFilePath(aKey);
        return file_put_contents(filename, contents) > 0;
    }
}
