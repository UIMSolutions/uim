module uim.css.media;

import uim.css;
@safe:

class DCSSMedia : DCSSRules {
	this() { super(); }
	this(string aName) { this(); this.name = aName; }
	this(string aName, DCSSRule[] someRules) { this(aName).rules(someRules); }
	this(string aName, DCSSRules aRules) { this(aName).rules(aRules); }

	override protected void _init() { super._init; }

	mixin(PropertyDefinition!("string", "name"));

	override string toString() {
		return "@media %s{%s}".format(this.name, super.toString);
	}
}
auto CSSMedia() { return new DCSSMedia(); }
auto CSSMedia(string aName) { return new DCSSMedia(aName); }


enum CSSMediaTypes : string {
	All = "all", //Used for all media type devices
	Print = "print", // Used for printers
	Screen = "screen", //Used for computer screens, tablets, smart-phones etc.
	Speech = "speech" // 	Used for screenreaders that "reads" the page out loud
}

unittest {
	// TODO
}
