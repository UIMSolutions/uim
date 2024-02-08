/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.lookups.lookup;

import uim.models;

@safe:
class DLookupValue(K, V) : DData {
  mixin(DataThis!("LookupValue"));

  V[K] _items;

  DLookupValue opIndexAssign(V value, K key) {
    _items[key] = value;
    return this;
  }

  V opIndex(this O)(K key) {
    return _items.get(key, null);
  }

  bool isEmpty() {
    return (_items.length == 0);    
  }

  size_t length() {
    return _items.length;    
  }

  alias opEquals = Object.opEquals;
  alias opEquals = DData.opEquals;

  override IData copy() {
    return LookupValue!(K, V)(attribute, toJson);
  }
  override IData dup() {
    return copy;
  }
}
auto LookupValue(K, V)() { return new DLookupValue!(K, V); }
auto LookupValue(K, V)(DAttribute theAttribute) { return new DLookupValue!(K, V)(theAttribute); }
auto LookupValue(K, V)(string theValue) { return new DLookupValue!(K, V)(theValue); }
auto LookupValue(K, V)(Json theValue) { return new DLookupValue!(K, V)(theValue); }
auto LookupValue(K, V)(DAttribute theAttribute, string theValue) { return new DLookupValue!(K, V)(theAttribute, theValue); }
auto LookupValue(K, V)(DAttribute theAttribute, Json theValue) { return new DLookupValue!(K, V)(theAttribute, theValue); }

///
unittest {  
  auto stringAALookup = LookupValue!(string, string)();
  stringAALookup["key1"] = "value1";

  assert(stringAALookup["key1"] == "value1");
}