/*********************************************************************************************************
	Copyright: © 2015 - 2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.configurations.configuration;

import uim.oop;
@safe:

class Configuration : IConfiguration {
    this() {}
    this(string name) { this(); this.name(name); }

    // Name of configuration
    protected string _name;

    // Get name of configuration
    string name() {
        return _name;
    }

    // Set name of configuration
    IConfiguration name(string newName) {
        _name = newName;
        return this;
    }
}

unittest{
    IConfiguration config = new Configuration;
    // config["test"] = StringData("stringdata");
    // config.data("data", StringData("string-data"));
}