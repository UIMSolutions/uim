/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.core.aggregation;

import uim.oop;

/* template OOPAGGREGATION(string name, string datatype, bool isMultiple = false, bool isDefault = false) {
	const char[] OOPAGGREGATION = `
	@OOP_AGGREGATION("`~name~`", "`~datatype~`", `~(isMultiple ? "true" : "false")~`, `~(isDefault ? "true" : "false")~`) `~datatype~` _`~name~`;
	@property `~datatype~` `~name~`() { return _`~name~`; }
`;
} */

class DAggregation : DOOPElement {
	mixin(ThisElement!()); 

	this(string newName, string newDataType, bool newMultiple = false, bool newDefaultAgg = false) { 
		super(newName); 
		_datatype = newDataType;
		_isMultiple = newMultiple; 
		_isDefault = newDefaultAgg; 
	}

	mixin(TProperty!("string", "datatype"));
	mixin(TProperty!("bool", "isMultiple"));
	mixin(TProperty!("bool", "isDefault"));
}
mixin(ShortCutElement!("Aggregation", "DAggregation")); 

version(test_uim_oop) { unittest {
		assert(Aggregation("Werte").name == "Werte");
		assert(Aggregation("Werte").name("Anderes").name == "Anderes");
}}
