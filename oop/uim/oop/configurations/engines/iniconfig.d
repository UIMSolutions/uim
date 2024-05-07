module uim.oop.configurations.engines.iniconfig;

import uim.oop;

@safe:

/**
 * Ini file configuration engine.
 *
 * Since IniConfig uses parse_ini_file underneath, you should be aware that this
 * class shares the same behavior, especially with regards to boolean and null values.
 *
 * In addition to the native `parse_ini_file` features, IniConfig also allows you
 * to create nested array structures through usage of `.` delimited names. This allows
 * you to create nested arrays structures in an ini config file. For example:
 *
 * `db.password = secret` would turn into `["db": ["password": `secret"]]`
 *
 * You can nest properties as deeply as needed using `.``s. In addition to using `.` you
 * can use standard ini section notation to create nested structures:
 *
 * ```
 * [section]
 * key = value
 * ```
 *
 * Once loaded into Configure, the above would be accessed using:
 *
 * `Configuration.read("section.key");
 *
 * You can also use `.` separated values in section names to create more deeply
 * nested structures.
 *
 * IniConfig also manipulates how the special ini values of
 * 'yes", "no", "on", "off", "null' are handled. These values will be
 * converted to their boolean equivalents.
 */
class DIniConfig : IConfigEngine {
    mixin TFileConfig;
    /*
  	override bool initialize(Json[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}


    // File extension.
    protected string _fileExtension = ".ini";

    // The section to read, if null all sections will be read.
    protected string _section = null;

    /**
     * Build and construct a new ini file parser. The parser can be used to read
     * ini files that are on the filesystem.
     * Params:
     * string someKey Key to load ini config files from. Defaults to CONFIG.
     * @param string section Only get one section, leave null to parse and fetch
     *    all sections in the ini file.
     * /
    this(string aKey = null, string asection = null) {
       _key = someKey ? someKey : CONFIG;
       _section = section;
    }
    
    /**
     * Read an ini file and return the results as an array.
     * Params:
     * string aKey The identifier to read from. If the key has a ~ it will be treated
     * as a plugin prefix. The chosen file must be on the engine`s key.
     * /
    array read(string aKey) {
        file = _getFileKey(aKey, true);

        contents = parse_ini_file(file, true);
        if (contents == false) {
            throw new UimException("Cannot parse INI file `%s`".format(file));
        }
        if (_section && isSet(contents[_section])) {
             someValues = _parseNestedValues(contents[_section]);
        } else {
             someValues = null;
            foreach (section: attribs; contents) {
                if (isArray(attribs)) {
                     someValues[section] = _parseNestedValues(attribs);
                } else {
                    parse = _parseNestedValues([attribs]);
                     someValues[section] = array_shift(parse);
                }
            }
        }
        return someValues;
    }
    
    /**
     * parses nested values out of keys.
     * Params:
     * Json[string] someValues Values to be exploded.
     * /
    // TODO protected Json[string] _parseNestedValues(Json[string] someValues) {
        someValues.byKeyValue
            .each!((kv) {
            if (kv.value == "1") {
                kv.value = true;
            }
            if (kv.value.isEmpty) {
                kv.value = false;
            }
            unset(someValues[kv.key]);
            if (to!string(kv.key).has(".")) {
                 someValues = Hash.insert(someValues, kv.key, kv.value);
            } else {
                 someValues[kv.key] = kv.value;
            }
        });
        return someValues;
    }
    
    /**
     * Dumps the state of Configure data into an ini formatted string.
     * Params:
     * string aKey The identifier to write to. If the key has a ~ it will be treated
     * as a plugin prefix.
     * @param Json[string] data The data to convert to ini file.
     * /
    bool dump(string key, Json[string] data) {
        auto result;
        someData.byKeyValue
            .each!((kv) {
                isSection = false;
                if (kv.key[0] != "[") {
                    result ~= "["+kv.key~"]";
                    isSection = true;
                }
                if (isArray(aValue)) {
                    Hash.flatten(kv.value, ".").byKeyValue
                        .each!(kv2 => result ~= "%s = %s".format(kv2.key, _value(kv2.value)));
                }
                if (isSection) {
                    result ~= "";
                }
            });

        string contents = strip(result.join("\n"));
        auto filename = _getFileKey(key);
        return file_put_contents(filename, contents) > 0;
    }
    
    /**
     * Converts a value into the ini equivalent
     * Params:
     * Json aValue Value to export.
     * /
    protected string _value(Json valueToExport) {
        return match (aValue) {
            null: "null",
            true: "true",
            false: "false",
            default: to!string(valueToExport)
        };
    } */
}
