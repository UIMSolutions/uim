module uim.css.declaration;

import uim.css;
@safe:

class DCSSDeclaration : DCSSObj {
	this() { super(); }
	this(string aName) { this.name(aName); }
	this(string aName, string aValue) { this.name(aName).value(aValue); }

	override protected void _init() { super._init; }

	mixin(PropertyDefinition!("string", "name"));
	mixin(PropertyDefinition!("string", "value"));

alias opEquals = Object.opEquals;
  bool opEquals(string css) { return toString == css; }
	bool opEquals(DCSSDeclaration obj) { return toString == obj.toString; }

	override string toString() {
		return name~": "~value;
	}
}
auto CSSDeclaration() { return new DCSSDeclaration(); }
auto CSSDeclaration(string aName) { return new DCSSDeclaration(aName); }
auto CSSDeclaration(string aName, string aValue) { return new DCSSDeclaration(aName,aValue); }

version(test_uim_css) { unittest {
		assert(CSSDeclaration("background-color", "lightgreen") == "background-color:lightgreen"); }}
