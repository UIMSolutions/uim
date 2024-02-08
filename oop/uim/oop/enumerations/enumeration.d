/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.enumerations.enumeration; 

import uim.oop;
@safe:

class DEnumeration(K, V) : IEnumeration {
  this() {
  }
  
  bool initialize(Json Data = null) {}
                  
  private K[] _keys;
  private V[] _values;
  
  auto keyValues() {
    K[V][] results;
  }   
  
  auto value(K key) {
    foreach(key; keys) {
      
    }
    return NullValue;
  } 
  
  
}
