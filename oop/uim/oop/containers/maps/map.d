/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
***********************************************************************************/
module uim.oop.containers.maps.map;

import uim.oop;
@safe:

class DMap(T : Object) : IMap {
	this() {}

	protected T[string] _values;

	bool isEmpty() { return length == 0; }
	size_t length() { return _values.length; }

	bool removeByKey(string[] keys) {
		return keys.all!(key => _values.removeByKey(key));
	}
	bool removeItem(string key) {
		return _values.removeByKey(key);
	}
	void clear(this O)() { 
		_values = null; 
	}

	override string toString() {
		return "%s".format(_values.byKeyValue.map!(value => value.toString).array);
	}
}

version(test_uim_oop) { unittest {
	// TODO auto map = new DMapObj;
}}
