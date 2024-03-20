module uim.cake.core\Configure\Engine;

import uim.cake;

@safe:

/**
 * JSON engine allows Configure to load configuration values from
 * files containing JSON strings.
 *
 * An example JSON file would look like.
 *
 * ```
 * {
 *    "debug": false,
 *    "App": {
 *        "namespace": "MyApp"
 *    },
 *    "Security": {
 *        "salt": "its-secret"
 *    }
 * }
 * ```
 */
class JsonConfig : IConfigEngine {
  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}
    mixin FileConfigTemplate();

    // File extension.
    protected string _extension = ".json";

    /**
     * Constructor for IData[string] configSettings = null file reading.
     * Params:
     * string somePath The path to read config files from. Defaults to CONFIG.
     */
    this(string pathToConfig = null) {
       _path = !pathToConfig.isEmpty ? pathToConfig : CONFIG;
    }
    
    /**
     * Read a config file and return its contents.
     *
     * Files with `.` in the name will be treated as values in plugins. Instead of
     * reading from the initialized path, plugin keys will be located using Plugin.path().
     * Params:
     * string aKey The identifier to read from. If the key has a ~ it will be treated
     *  as a plugin prefix.
     */
    array read(string aKey) {
        auto file = _getFilePath(aKey, true);

        auto jsonContent = file_get_contents(file);
        if (jsonContent == false) {
            throw new UimException("Cannot read file content of `%s`".format(file));
        }
         someValues = json_decode(jsonContent, true);
        if (json_last_error() != JSON_ERROR_NONE) {
            throw new UimException(
                "Error parsing JSON string fetched from config file `%s.json`: %s"
                .format(aKey, json_last_error_msg()
            ));
        }
        if (!isArray(someValues)) {
            throw new UimException(
                "Decoding IData[string] configSettings = null file `%s.json` did not return an array"
                .format(aKey
            ));
        }
        return someValues;
    }
    
    /**
     * Converts the provided someData into a JSON string that can be used saved
     * into a file and loaded later.
     * Params:
     * string aKey The identifier to write to. If the key has a ~ it will
     * be treated as a plugin prefix.
     * @param array data Data to dump.
         */
    bool dump(string dataId, array data) {
        auto filename = _getFilePath(dataId);

        return file_put_contents(filename, json_encode(someData, JSON_PRETTY_PRINT)) > 0;
    }
}