module uim.oop.core\Configure\Engine;

import uim.oop;

@safe:

/**
 * IData engine allows Configure to load configuration values from
 * files containing IData strings.
 *
 * An example IData file would look like.
 *
 * ```
 * {
 *    "debug": BooleanData(false),
 *    "App": {
 *        "namespace": "MyApp"
 *    },
 *    "Security": {
 *        "salt": "its-secret"
 *    }
 * }
 * ```
 */
class DIDataConfig : IConfigEngine {
  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}
    mixin FileConfigTemplate();

    // File extension.
    protected string _extension = ".IData";

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

        auto IDataContent = file_get_contents(file);
        if (IDataContent == false) {
            throw new UimException("Cannot read file content of `%s`".format(file));
        }
         someValues = IData_decode(IDataContent, true);
        if (IData_last_error() != IData_ERROR_NONE) {
            throw new UimException(
                "Error parsing IData string fetched from config file `%s.IData`: %s"
                .format(aKey, IData_last_error_msg()
            ));
        }
        if (!isArray(someValues)) {
            throw new UimException(
                "Decoding IData[string] configSettings = null file `%s.IData` did not return an array"
                .format(aKey
            ));
        }
        return someValues;
    }
    
    /**
     * Converts the provided someData into a IData string that can be used saved
     * into a file and loaded later.
     * Params:
     * string aKey The identifier to write to. If the key has a ~ it will
     * be treated as a plugin prefix.
     * @param array data Data to dump.
         */
    bool dump(string dataId, array data) {
        auto filename = _getFilePath(dataId);

        return file_put_contents(filename, IData_encode(someData, IData_PRETTY_PRINT)) > 0;
    }
}