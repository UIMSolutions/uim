/*********************************************************************************************************
	Copyright: © 2015 - 2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.configurations.data.string;

import uim.oop;

@safe:

class DStringConfigData : DConfigData {
	mixin(ConfigDataThis!());
    this(string newValue) {
        _value = newValue;
    }

    protected string _value;

    override string toString() {
        return _value;
    }
}
mixin(ConfigDataCalls!("StringConfigData"));
auto StringConfigData(string newValue) { return new DStringConfigData(newValue); }