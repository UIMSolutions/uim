/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.containers.maps.map;

import uim.oop;
@safe:

class DMap(T : Object) : IMap {
	this() {}

	protected T[string] _values;

	bool isEmpty() { return length == 0; }
	size_t length() { return _values.length; }

	void remove(string[] keys) {
		keys.each!(key => _values.remove(key));
	}
	void remove(string key) {
		_values.remove(key);
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
