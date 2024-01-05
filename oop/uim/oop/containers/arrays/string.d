/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.containers.arrays.string;

import uim.oop;

class DArrayString : DArrayTempl!string { 
	this() { super(); } 
	this(bool sortedMode, bool uniqueMode) { super(sortedMode, uniqueMode); }
	this(string[] values) { super(values); }
	this(string[] values...) { super(values); }
	this(bool sortedMode, bool uniqueMode, string[] values) { super(sortedMode, uniqueMode, values); }

	O opCall(this O)(string[] newItems...) { 
		newItems.each!(item => this.add(item)); 		

		return cast(O)this;
	}

	O opCall(this O)(string[] newItems) { 
		newItems.each!(item => this.add(item)); 		

		return cast(O)this;
	}

	string join(string separator) { 
		return _items.join(separator); 
	}

	string toHTML() { 
		return join(" "); 
	}

}
auto ArrayString() { return new DArrayString(); }
auto ArrayString(bool sortedMode, bool uniqueMode) { return new DArrayString(sortedMode, uniqueMode); }
auto ArrayString(string[] values) { return new DArrayString(values); }
auto ArrayString(string[] values...) { return new DArrayString(values); }
auto ArrayString(bool sortedMode, bool uniqueMode, string[] values) { return new DArrayString(sortedMode, uniqueMode, values); }

version(test_uim_oop) { unittest { /// TODO 
}}
