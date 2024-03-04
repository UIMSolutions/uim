/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.configurations.configuration;

import uim.oop;
@safe:

class DConfiguration : IConfiguration {
    this() {}
    this(string name) { this(); this.name(name); }

  	bool initialize(IData[string] initData = null) {
		return true;
	}

    mixin(TProperty!("string", "name"));
    
    IData[string] data() {
        return null;
    }

    void data(IData[string] newData) {
    }

    bool hasAllKeys(string[] keys...) {
        return false;
    }

    bool hasAllKeys(string[] keys) {
        return false;
    }

    bool hasKey(string key) {
        return false;
    }

    bool hasValues(string[] values...) {
        return false;
    }

    bool hasValues(string[] values) {
        return false;
    }

    bool hasValue(string value) {
        return false;
    }

    IData get(string key) {
        return null;
    }

    IData[string] get(string[] keys);

    void set(string key, IData newData);
    void set(string[] keys, IData[string] newData);

    void update(IData[string] newData);

    void remove(string[] keys);
}

unittest{
    IConfiguration config = new Configuration;
    // config["test"] = StringData("stringdata");
    // config.data("data", StringData("string-data"));
}