/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.core.event;

import uim.oop;
@safe:

template OOPEVENT(string name, string defaultValue = "", bool readOnly = false) {
	const char[] OOPEVENT = `
	@OOP_EVENT("`~name~`", "`~defaultValue~`", `~(readOnly ? "true" : "false")~`) string _`~name~``~((defaultValue.length > 0) ? (" = "~defaultValue) : "")~`;
	@property string `~name~`() { return _`~name~`; }
	`~(!readOnly ? `@property O `~name~`(this O)(string newValue) { _`~name~` = newValue; return cast(DO)this; }` : "");
}

/* class DEvent : DOOPElement {
	mixin(ThisElement!()); 
	this(string aName, string aDataType, string aDefaultValue, bool isReadOnly = false) { 
		super(aName); 
		_defaultValue = aDefaultValue; 
		_readOnly = isReadOnly; 
	}
	mixin(PropertyDefinition!("string", "_defaultValue", "defaultValue"));
	mixin(PropertyDefinition!("bool", "_readOnly", "readOnly"));
}
mixin(ShortCutElement!("Event", "DEvent")); 

version(test_uim_oop) { unittest {
		/// TODO
	}} */
