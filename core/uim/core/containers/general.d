/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (UIManufaktur)										                         * 
***********************************************************************************************************************/
module uim.core.containers.general;

@safe:
import uim.core;
  
bool isSet(V)(V value) {
  return !(value is null);
} 

bool isSet(V)(Nullable!V value) {
  return !value.isNull;
}

bool isSet(V)(V[] values) {
  return !values.empty;
}
///
unittest {
  
}

bool isSet(V)(V[] values, size_t[] index...) {
  return isSet(values, index);

}
bool isSet(V)(V[] values, size_t[] index) {
  if (index.length == 0) { 
      return false; 
    }

  foreach (i; index) {
    if (i >= values.length) { 
      return false; 
    }
  }
  return true;
}

