/*********************************************************************************************************
	Copyright: © 2015 - 2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.configurations.data.integer;

import uim.oop;

@safe:

class DIntegerConfigData : DConfigData {
  mixin(ConfigDataThis!());

  this(int newValue) {
    _value = newValue;
  }

  protected int _value;

  override string toString() {
    return to!string(_value);
  }
}

mixin(ConfigDataCalls!("IntegerConfigData"));

unittest {
  auto data = IntegerConfigData(100);
  writeln(data.className);
}
