/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.lookups.lookup;

import uim.models;

@safe:
class DLookupData(K, V) : DData {
  mixin(DataThis!("LookupData"));

  V[K] _items;

  DLookupData opIndexAssign(V value, K key) {
    _items[key] = value;
    return this;
  }

  V opIndex(K key) {
    return _items.get(key, null);
  }

  bool isEmpty() {
    return (_items.length == 0);    
  }

  override size_t length() {
    return _items.length;    
  }

  alias opEquals = Object.opEquals;
  alias opEquals = DData.opEquals;

  override IData clone() {
    return LookupData!(K, V)(attribute, toJson);
  }
}
auto LookupData(K, V)() { return new DLookupData!(K, V); }
auto LookupData(K, V)(DAttribute theAttribute) { return new DLookupData!(K, V)(theAttribute); }
auto LookupData(K, V)(string theValue) { return new DLookupData!(K, V)(theValue); }
auto LookupData(K, V)(Json theValue) { return new DLookupData!(K, V)(theValue); }
auto LookupData(K, V)(DAttribute theAttribute, string theValue) { return new DLookupData!(K, V)(theAttribute, theValue); }
auto LookupData(K, V)(DAttribute theAttribute, Json theValue) { return new DLookupData!(K, V)(theAttribute, theValue); }

///
unittest {  
  auto stringAALookup = LookupData!(string, string)();
  stringAALookup["key1"] = "value1";

  assert(stringAALookup["key1"] == "value1");
}