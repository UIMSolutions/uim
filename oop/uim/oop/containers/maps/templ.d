/***********************************************************************************
*	Copyright: ©2015-2023 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.containers.maps.templ;

import uim.oop;

@safe:
class MapTempl(K, V): Map {
	V[K] _items;

	this() { super(); }
	this(V[K] values) { this(); this.items(values); }

	@property V[K] items() { return _items; }
	@property O items(this O)(V[K] newItems) { _items = newItems.dup; return cast(O)this; }

	override bool isEmpty() { return (length == 0); }
	override size_t length() { return _items.length; }

	K[] keys(bool sorted = false) { 
		auto k = _items.keys; 
		if (sorted) k = k.sort.array;
		return k;
	}
	V[] values(bool sorted = false) { 
		auto v = _items.values; 
		if (sorted) v = v.sort.array; 
		return v; 
	}

	// has is Shortcaut for hasKey
	bool has(K key) { return (key in _items) ? true : false; }

	bool hasAnyKeys(K[] keys...) { foreach(key; keys) if (hasKey(key)) { return true; } return false; }
	bool hasAllKeys(K[] keys...) { foreach(key; keys) if (!hasKey(key)) { 
      return false; 
    } return true; }
	bool hasKey(K key) { return (key in _items) ? true : false; }

	bool hasAnyValues(V[] values...) { foreach(value; values) if (hasValue(value)) { return true; } return false; }
	bool hasAllValues(V[] values...) { foreach(value; values) if (!hasValue(value)) { 
      return false; 
    } return true; }
	bool hasValue(V value) { foreach(k, v; _items) if (v == value) { return true; } return false; }

	O add(this O)(V[K] values) { foreach(k, v; values) this.add(k, v); return cast(O)this; }
	O add(this O)(K key, V value) { this[key] = value; return cast(O)this; }

//	auto opCast(T:STRINGAA)() {
//		T result;
//		foreach(k, v; items) result["%s".format(k)] = "%s".format(v);
//		return result;
//	}

	bool opEquals(V[K] values) {
		return (items == values);
	}
	void opAssign(V[K] values) {
		_items = values;
	}
	V opIndex(K key) {
		if (key in _items) return _items[key];
		static if ((std.traits.isNumeric!(V))) {
			return 0;
		}
		else return null;
	}
	V[] opIndex(K[] keys) {
		V[] results;
		foreach(k; keys) if (hasKey(k)) results ~= this[k];
		return results;
	}
	void opIndexAssign(V value, K key) {
		_items[key] = to!V(value);
	}
	O remove(this O)(K key) {
		_items.remove(key);
		return cast(O)this;
	}
	O remove(this O)(K[] someKeys) {
		foreach(key; someKeys) _items.remove(key);
		return cast(O)this;
	}
	O clear(this O)() {
		_items.clear;
		return cast(O)this;
	}

	string[] toStrings(string mask = "%s=%s") {
		string[] result;
		foreach(k, v; items) result ~= mask.format(k,v);
		return result;
	}

	string toHTML() {
		if (isEmpty) {
			return "";
		}

		string result;
		foreach(k, v; _items) {
			auto val = "%".format(v);
			if (val == "false") continue;

			result ~= val == "true" 
				? ` %s`.format(k)
				: ` %s="%s"`.format(k,v);
		}
		return result;
	}

	string toJSON() {
		if (isEmpty) {
			return "";
		}
		
		string result = _items
			.byKeyValue
			.map!(kv => `"%s"="%s"`.format(kv.key, kv.value))
			.join(",");
		
		return result;
	}

	string toCSS() {
		if (isEmpty) {
			return "";
		}
		
		return keys(true)
			.map!(key => `%s:%s`.format(key, this[key]))
			.join(";");
	}
	string toXML() {
		if (isEmpty) {
			return "";
		}
		
		string result = _items
			.byKeyValue
			.map!(kv => ` %s="%s"`.format(kv.key, kv.value))
			.join;
			
		return result;
	}
}
auto OOPMap(K, V)() { return DOOPMap!(K, V)(); }
auto OOPMap(K, V)(V[K] values) { return DOOPMap!(K, V)(values); }

version(test_uim_oop) { unittest {
	import std.stdio;

	auto map = new MapTempl!(string, string);
	map.items = ["1":"2", "3":"4"];
	assert(map.items == ["1":"2", "3":"4"]);

	auto map2 = new MapTempl!(int, int);
	map2.items = [1:2, 3:5];
	assert(map2.items == [1:2, 3:5]);

	assert(map.hasAllKeys(["1", "3"]) == true);
	assert(map.hasAllKeys(["1", "2"]) == false);
	assert(map.hasAnyKeys(["1", "3"]) == true);
	assert(map.hasAnyKeys(["1", "2"]) == true);
	assert(map.hasAnyKeys(["5", "2"]) == false);
	assert(map.hasKey("1") == true);
	assert(map.hasKey("5") == false);

	assert(map.items(["X":"Y", "XX":"YY"]) == ["X":"Y", "XX":"YY"]);

	assert(map.hasAllValues(["Y", "YY"]) == true);
	assert(map.hasAllValues(["Y", "YYY"]) == false);
	assert(map.hasAnyValues(["Y", "YY"]) == true);
	assert(map.hasAnyValues(["Y", "YY"]) == true);
	assert(map.hasAnyValues(["Z", "ZZZ"]) == false);
	assert(map.hasValue("Y") == true);
	assert(map.hasValue("Z") == false);
}}
