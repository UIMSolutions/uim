module uim.oop.configurations.engines.jsonconfig;

import uim.oop;

@safe:

/**
 * Json engine allows Configure to load configuration values from
 * files containing Json strings.
 *
 * An example Json file would look like.
 *
 * ```
 * {
 *    "debug": Json(false),
 *    "App": {
 *        "namespace": "MyApp"
 *    },
 *    "Security": {
 *        "salt": "its-secret"
 *    }
 * }
 * ```
 */
class DJsonConfig : IConfigEngine {
    // mixin TFileConfig();
  	/*alias Alias = ;
    override bool initialize(Json[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}

    // File extension.
    protected string _extension = ".json";

    /**
     * Constructor for Json[string] configSettings = null file reading.
     * Params:
     * string someKey The key to read config files from. Defaults to CONFIG.
     * /
    this(string keyToConfig = null) {
       _key = !keyToConfig.isEmpty ? keyToConfig : CONFIG;
    }
    
    /**
     * Read a config file and return its contents.
     *
     * Files with `.` in the name will be treated as values in plugins. Instead of
     * reading from the initialized key, plugin keys will be located using Plugin.key().
     * Params:
     * string aKey The identifier to read from. If the key has a ~ it will be treated
     *  as a plugin prefix.
     * /
    array read(string aKey) {
        auto file = _getFileKey(aKey, true);

        auto JsonContent = file_get_contents(file);
        if (JsonContent == false) {
            throw new UimException("Cannot read file content of `%s`".format(file));
        }
         someValues = Json_decode(JsonContent, true);
        if (Json_last_error() != Json_ERROR_NONE) {
            throw new UimException(
                "Error parsing Json string fetched from config file `%s.Json`: %s"
                .format(aKey, Json_last_error_msg()
            ));
        }
        if (!isArray(someValues)) {
            throw new UimException(
                "Decoding Json[string] configSettings = null file `%s.Json` did not return an array"
                .format(aKey
            ));
        }
        return someValues;
    }
    
    /**
     * Converts the provided someData into a Json string that can be used saved
     * into a file and loaded later.
     * Params:
     * string aKey The identifier to write to. If the key has a ~ it will
     * be treated as a plugin prefix.
     * @param array data Data to dump.
         * /
    bool dump(string dataId, Json[string] data) {
        auto filename = _getFileKey(dataId);

        return file_put_contents(filename, Json_encode(someData, Json_PRETTY_PRINT)) > 0;
    } */
}