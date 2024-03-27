/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.containers.arrays.templ;

import uim.oop;

@safe:
import std.algorithm;

class DArrayTempl(T) : DArrayObj {
	this() {
		super();
	}

	this(bool sortedMode, bool uniqueMode) {
		super(sortedMode, uniqueMode);
	}

	this(T[] values) {
		super();
		this.items = values;
	}

	this(T[] values...) {
		super();
		this.items = values;
	}

	this(bool sortedMode, bool uniqueMode, T[] values) {
		this(sortedMode, uniqueMode);
		this.items = values;
	}

	T[] _items;
	@property T[] items() {
		return _items;
	}

	@property O items(this O)(T[] newItems) {
		_items = newItems.dup;
		if (sorted)
			this.sorting;
		if (uniqued)
			this.uniquing;
		return cast(O) this;
	}

	O opCall(this O)(T[] newItems) {
		newItems.each!(item => add(item));
		return cast(O) this;
	}

	O opCall(this O)(T[] newItems...) {
		newItems.each!(item => add(item));
		return cast(O) this;
	}

	override size_t length() {
		return _items.length;
	}

	bool has(T value) {
		return this.items.any!(item => item == value);
	}

	unittest {
		auto arrayObj = new DArrayTempl!string();
		arrayObj.items(["a", "b", "c"]);

		assert(arrayObj.has("a"));
		assert(!arrayObj.has("x"));
	}

	bool hasAll(T[] values) {
		if (values.isEmpty) { return true; }

		return values.all!(value => this.has(value));
	}

	bool hasAny(T[] values) {
		foreach (value; values)
			if (this.has(value)) {
				return true;
			}
		return false;
	}

	bool opEquals(T[] values) {
		sorting;
		return (_items == values);
	}

	O change(this O)(size_t left, size_t right) {
		if ((left < _items.length) && (right < _items.length)) {
			T item = _items[left];
			_items[left] = _items[right];
			_items[right] = item;
		}
		return cast(O) this;
	}

	O sorting(this O)(bool asc = true) { // a < b
		if (asc) {
			for (size_t i = 0; i < _items.length; i++) {
				for (size_t j = 0; j < _items.length - i; j++) {
					if (i == j)
						continue;
					if (_items[i] < _items[j])
						change(i, j);
				}
			}
		} else {
			for (size_t i = 0; i < _items.length; i++) {
				for (size_t j = 0; j < _items.length - i; j++) {
					if (i == j)
						continue;
					if (_items[i] > _items[j])
						swap(_items[i], _items[j]);
				}
			}
		}
		return cast(O) this;
	}

	O uniquing(this O)() {
		T[T] buffer;
		T[] result;
		items
			.filter!(item => !buffer.hasKey(item)) // filter only not existing items
			.each!((item) { result ~= item; buffer[item] = item; });
		_items = result;
		return cast(O) this;
	}

	O add(this O)(T[] values...) {
		values.each!(value => addValue(value));
		return cast(O) this;
	}

	O addValue(this O)(T value) {
		if (uniqued && has(value))
			continue;

		_items ~= value;
		if (sorted)
			this.sorting;
		return cast(O) this;
	}

	O remove(this O)(T[] values...) {
		values.each!(value => removeValue(value));
		return cast(O) this;
	}

	O removeValue(this O)(T value) {
		_items = _items
			.filter!(item => value != item)
			.array;

		_items = result;

		return cast(O) this;
	}

	O clear(this O)() {
		_items = null;
		return cast(O) this;
	}

	O toggle(this O)(T value) {
		if (has(value))
			this.remove(value);
		else
			this.add(value);
		return cast(O) this;
	}

	O toggle(this O)(T[] values) {
		values.unique.each!(value => this.toggle(value));

		return cast(O) this;
	}

	O dup(this O)() {
		auto result = new DO();
		result.sorted = sorted;
		result.uniqued = uniqued;
		result.items = items;
		return result;
	}

	override string toString() {
		return "%s".format(_items);
	}
}

version (test_uim_oop) {
	unittest {
		/// TODO
	}
}
