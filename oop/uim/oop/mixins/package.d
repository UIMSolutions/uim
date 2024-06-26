/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
***********************************************************************************/
module uim.oop.mixins;

import uim.oop;

public {
	import uim.oop.mixins.properties;
}

public {
	import uim.oop.mixins.cloneable;
	import uim.oop.mixins.configurable;
	import uim.oop.mixins.configuration;
	import uim.oop.mixins.conventions;
	import uim.oop.mixins.cookiecrypt;
	import uim.oop.mixins.element;
	import uim.oop.mixins.exception;
	import uim.oop.mixins.fileconfig;
	import uim.oop.mixins.mergevariables;
	import uim.oop.mixins.staticconfig;
	import uim.oop.mixins.valuemap;
}

template ThisElement() {
	const char[] ThisElement = `
	this() { super(); }
	this(string aName) { super(aName); }
	`;
}

template ShortCutElement(string shortcut, string original) {
	const char[] ShortCutElement = `
	`~original~` `~shortcut~`() { return new `~original~`(); }
	`~original~` `~shortcut~`(string aName) { return new `~original~`(aName); }
	`;
}

template SProperty(string dataType, string propertyName) {
	const char[] SProperty = "
	protected "~dataType~" _"~propertyName~";
	@property "~dataType~" "~propertyName~"() { return _"~propertyName~"; }
	@property O "~propertyName~"(this O)("~dataType~" newValue) { _"~propertyName~" = newValue; return cast(O)this; }";
}
