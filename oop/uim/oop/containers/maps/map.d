/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.containers.maps.map;

import uim.oop;
@safe:

class Map : Obj, IMap {
	this() {}

	bool isEmpty() { return true; }
	size_t length() { return 0; }
	O clear(this O)() { return cast(O)this; }

	override string toString() {
		return super.toString;
	}
}

version(test_uim_oop) { unittest {
	auto map = new MapObj;
}}
