/*********************************************************************************************************
	Copyright: © 2015 - 2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.configurations.data.string;

import uim.oop;

@safe:

class DStringData : DData {
	mixin(DataThis!());
    this(string newValue) {
        _value = newValue;
    }

    protected string _value;

    override string toString() {
        return _value;
    }
}
mixin(DataCalls!("StringData"));
auto StringData(string newValue) { return new DStringData(newValue); }