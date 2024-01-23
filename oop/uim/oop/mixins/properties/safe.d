/***********************************************************************************
*	Copyright: ©2015 - 2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.mixins.properties.safe;

import uim.oop;

// Mixin for a safe getter 
auto SPropertyGet(string dataType, string propertyName) { return "@safe @property "~dataType~" "~propertyName~"() { return _"~propertyName~"; }"; }
template SProperty_get(string dataType, string propertyName) {
	const char[] SProperty_get = SPropertyGet(dataType, propertyName);
}
version(test_uim_oop) { unittest {
	class Test{ int _a = 1; mixin(SProperty_get!("int", "a")); }
 	assert((new Test).a == 1);
}}

// Mixin for a safe setter 
auto SPropertySet(string dataType, string propertyName) { return "@safe @property O "~propertyName~"(this O)("~dataType~" value) { _"~propertyName~" = value; return cast(O)this; }"; }
template SProperty_set(string dataType, string propertyName) {
	const char[] SProperty_set = SPropertySet(dataType, propertyName);
}
version(test_uim_oop) { unittest {
	class Test{ int _a = 1; mixin(SProperty_set!("int", "a")); }
 	assert((new Test).a(1)._a == 1);
}}

// Mixin for a safe getter and setter 
template SProperty_getset(string dataType, string propertyName, bool getter = false, bool setter = false) { 
	const char[] SProperty_set = "@safe @property O "~propertyName~"(this O)("~dataType~" value) { _"~propertyName~" = value; return cast(O)this; }";
}
version(test_uim_oop) { unittest {
	class Test{ int _a = 1; mixin(SProperty_set!("int", "a")); }
 	assert((new Test).a(1)._a == 1);
}}
