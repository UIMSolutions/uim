/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.enumerations.enumeration; 

import uim.oop;
@safe:

class DEnumeration(K, V) : IEnumeration, ICloneable {
  this() {
    initialize;
  }
  
  bool initialize(Json[string] initData = null) {
    return true;
  }
                  
  private K[] _keys;
  private V[] _values;
  
  auto keyValues() {
    K[V][] results;
    return null; 
  }   
  
  auto value(K key) { // TODO
    /* foreach(key; keys) {
      
    }*/ 
    return null;
  } 
  mixin TCloneable;
}
unittest {
  auto enumeration = new DEnumeration!(string, string);
  assert(enumeration.className == "DEnumeration");
  assert(enumeration.create.className == "DEnumeration");
  assert(enumeration.clone.className == "DEnumeration");
}