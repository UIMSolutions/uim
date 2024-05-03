/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.containers.arrays.obj;

import uim.oop;

@safe:

class DArrayObj : Obj {
	Obj[] _objs;

	mixin(TProperty!("bool", "isSorted"));
	mixin(TProperty!("bool", "isUniqued"));

	this() {
		super();
	}

	this(bool sortedMode, bool uniqueMode) {
		this();
		this.isSorted = sortedMode;
		this.isUniqued = uniqueMode;
	}

	size_t length() {
		return 0;
	}

	bool isEmpty() {
		return (this.length == 0);
	}

	O clear(this O)() {
		return cast(O) this;
	}

	O sorting(this O)() {
		return cast(O) this;
	}

	O uniquing(this O)() {
		foreach (i, oi; _objs[0 .. -1]) {
			if (oi) {
				foreach (j, oj; _objs[i + 1 .. $]) {
					if (oj && oi == oj)
						_objs[j] = null;
				}
			}
		}
		_objs = _objs.filter!(obj => !obj.isNull).array;

		return cast(O) this;
	}

	O dup(this O)() {
		auto result = ArrayObj();
		result.sortedMode = sorted;
		result.uniqueMode = uniqued;
		return result;
	}

	/* override size_t toHash() nothrow {
		return super.toHash;
	} */

	override string toString() {
		return super.toString;
	}
}

auto ArrayObj() {
	return new DArrayObj();
}

auto ArrayObj(bool sortedMode, bool uniqueMode) {
	return new DArrayObj(sortedMode, uniqueMode);
}

version (test_uim_oop) {
	unittest {
		assert(ArrayObj.empty);
		assert(ArrayObj(true, true).isSorted);
		assert(!ArrayObj(false, true).isSorted);
		assert(ArrayObj(true, true).isUniqued);
		assert(!ArrayObj(true, false).isUniqued);
	}
}
