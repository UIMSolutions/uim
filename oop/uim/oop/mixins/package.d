/***********************************************************************************
*	Copyright: ©2015 - 2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.mixins;

import uim.oop;

public {
	import uim.oop.mixins.config;
	import uim.oop.mixins.configurable;
	import uim.oop.mixins.configdata;
	import uim.oop.mixins.configuration;
	import uim.oop.mixins.exception;
	import uim.oop.mixins.properties;
	import uim.oop.mixins.valuemap;
}


template ThisElement() {
	const char[] ThisElement = `
	@safe this() { super(); }
	@safe this(string aName) { super(aName); }
	`;
}

template ShortCutElement(string shortcut, string original) {
	const char[] ShortCutElement = `
	@safe `~original~` `~shortcut~`() { return new `~original~`(); }
	@safe `~original~` `~shortcut~`(string aName) { return new `~original~`(aName); }
	`;
}

template SProperty(string dataType, string propertyName) {
	const char[] SProperty = "
	protected "~dataType~" _"~propertyName~";
	@safe @property "~dataType~" "~propertyName~"() { return _"~propertyName~"; }
	@safe @property O "~propertyName~"(this O)("~dataType~" newValue) { _"~propertyName~" = newValue; return cast(O)this; }";
}
