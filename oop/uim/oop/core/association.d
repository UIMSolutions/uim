/***********************************************************************************
*	Copyright: ©2015 - 2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.core.association;

import uim.oop;

template OOPASSOCIATION(string name, string datatype, bool isMultiple = false) {
	const char[] OOPASSOCIATION = `
	@OOP_ASSOCIATION("`~name~`", "`~datatype~`", `~(isMultiple ? "true" : "false")~`) `~datatype~` _`~name~`;
	@property `~datatype~` `~name~`() { return _`~name~`; }
`;
}

class DAssociation : DOOPElement {
	mixin(ThisElement!()); 
	mixin(TProperty!("string", "datatype"));
	mixin(TProperty!("bool", "isMultiple"));
	mixin(TProperty!("bool", "isDefault"));

	this(string aName, string aDataType, bool isMultiple = false, bool isDefault = false) { 
		super(aName); 
		_datatype = aDataType;
		_isMultiple = isMultiple; 
	}	
}
mixin(ShortCutElement!("Association", "DAssociation")); 

version(test_uim_oop) { unittest {
		assert(Association("Werte").name == "Werte");
		assert(Association("Werte").name("Anderes").name == "Anderes");
}}
