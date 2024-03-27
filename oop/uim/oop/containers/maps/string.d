/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.containers.maps.string;

import uim.oop;

@safe:
class DMapString : MapTempl!(string, string) {
	this() {
		super();
	}

	this(STRINGAA values) {
		this();
		_items = values;
	}

	@property override STRINGAA items() {
		return _items;
	}

	@property STRINGAA items(string[] ignoreKeys) {
		STRINGAA result = _items.dup;
		foreach (k; ignoreKeys)
			result.remove(k);
		return result;
	}

	@property O items(this O)(STRINGAA newItems) {
		_items = newItems.dup;
		return cast(DO) this;
	}

	O add(this O)(STRINGAA values) {
		foreach (k, v; values)
			_items[k] = v;
		return cast(DO) this;
	}

	O add(this O)(STRINGAA[] values) {
		values.each!(value => add(value));
		return cast(DO) this;
	}

	O opCall(this O)(STRINGAA values) {
		add(values);
		return cast(DO) this;
	}

	void opIndexAssign(V, K)(V value, K key) {
		_items[key] = to!V(value);
	} // INFO: a function template is not virtual so cannot be marked `override`
	override void opIndexAssign(string value, string key) {
		_items[key] = value;
	}

	override string toHTML() {
		if (isEmpty) {
			return "";
		}

		string result;
		keys(true).each!((key) {
			auto v = this[key];
			auto val = "%s".format(v);
			if (val != "false") {
				result ~= val == "true"
					? ` %s`.format(key) : ` %s="%s"`.format(key, v);
			}
		});
		return result;
	}

	/* 
  override Json toJson(string[] showFields = null, string[] hifeFields = null) {    
    auto result = super.toJson(showFields, hideFields);
		if (isEmpty) return result;
		
		foreach(k; keys(true)) {
			result["k"] = this[k];
		}
		return result;
	} */
	override string toCSS() {
		if (isEmpty) {
			return "";
		}

		return keys(true)
			.map!(key => key ~ ":" ~ this[key])
			.join(";");
	}
}

auto MapString() {
	return new DMapString();
}

auto MapString(STRINGAA values) {
	return new DMapString(values);
}

version (test_uim_oop) {
	unittest {
		assert(MapString.items == null);
		assert(MapString([
					"a": "b",
					"c": "d"
				]) == ["a": "b", "c": "d"]);
		assert(MapString([
					"a": "b",
					"c": "d"
				]).items == ["a": "b", "c": "d"]);
		assert(MapString.items([
					"a": "b",
					"c": "d"
				]).items == ["a": "b", "c": "d"]);
		assert(MapString.items([
					"a": "b",
					"c": "d"
				]).keys(true) == ["a", "c"]);
		assert(MapString.items([
					"a": "b",
					"c": "d"
				]).values(true) == ["b", "d"]);
		assert(MapString.items([
					"a": "b",
					"c": "d"
				]).hasKey("a"));
		assert(!MapString.items([
					"a": "b",
					"c": "d"
				]).hasKey("x"));
		assert(MapString.items([
					"a": "b",
					"c": "d"
				]).hasAnyKeys("a", "x"));
		assert(!MapString.items([
					"a": "b",
					"c": "d"
				]).hasAnyKeys("x", "y"));
		assert(MapString.items([
					"a": "b",
					"c": "d"
				]).hasAllKeys("a", "c"));
		assert(!MapString.items([
					"a": "b",
					"c": "d"
				]).hasAllKeys("a", "x"));
		assert(!MapString.items([
					"a": "b",
					"c": "d"
				]).hasAllKeys("x", "y"));
		assert(MapString.items([
					"a": "b",
					"c": "d"
				]).hasValue("b"));
		assert(!MapString.items([
					"a": "b",
					"c": "d"
				]).hasValue("x"));
		assert(MapString.items([
					"a": "b",
					"c": "d"
				]).hasAnyValues("b", "x"));
		assert(!MapString.items([
					"a": "b",
					"c": "d"
				]).hasAnyValues("x", "y"));
		assert(MapString.items([
					"a": "b",
					"c": "d"
				]).hasAllValues("b", "d"));
		assert(!MapString.items([
					"a": "b",
					"c": "d"
				]).hasAllValues("b", "x"));
		assert(!MapString.items([
					"a": "b",
					"c": "d"
				]).hasAllValues("x", "y"));
		auto map = MapString([
				"a": "b",
				"c": "d"
			]);
		map = ["x": "y", "s": "t"];
		assert(map == [
				"x": "y",
				"s": "t"
			]);
		assert(map != ["a": "b", "c": "d"]);
		map["x"] = "b";
		assert(map == ["x": "b", "s": "t"]);
		assert(MapString([
					"a": "b",
					"c": "d"
				]).toHTML == ` a="b" c="d"`); // assert(MapString(["a":"b", "c":"d"]).toJSON == `"a":"b","c":"d"`); 
	}
}
