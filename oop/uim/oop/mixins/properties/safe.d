/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.mixins.properties.safe;

import uim.oop;

// Mixin for a safe getter 
auto SPropertyGet(string dataType, string propertyName) { return "@safe @property "~dataType~" "~propertyName~"() { return _"~propertyName~"; }"; }
template SProperty_get(string dataType, string propertyName) {
  const char[] SProperty_get = SPropertyGet(dataType, propertyName);
}
version(test_uim_oop) { unittest {
  class DTest{ int _a = 1; mixin(SProperty_get!("int", "a")); }
   assert((new DTest).a == 1);
}}

// Mixin for a safe setter 
auto SPropertySet(string dataType, string propertyName) { return "@safe @property O "~propertyName~"(this O)("~dataType~" value) { _"~propertyName~" = value; return cast(O)this; }"; }
template SProperty_set(string dataType, string propertyName) {
  const char[] SProperty_set = SPropertySet(dataType, propertyName);
}
version(test_uim_oop) { unittest {
  class DTest{ int _a = 1; mixin(SProperty_set!("int", "a")); }
   assert((new DTest).a(1)._a == 1);
}}

// Mixin for a safe getter and setter 
template SProperty_getset(string dataType, string propertyName, bool getter = false, bool setter = false) { 
  const char[] SProperty_set = "@safe @property O "~propertyName~"(this O)("~dataType~" value) { _"~propertyName~" = value; return cast(O)this; }";
}
version(test_uim_oop) { unittest {
  class DTest{ int _a = 1; mixin(SProperty_set!("int", "a")); }
   assert((new DTest).a(1)._a == 1);
}}
