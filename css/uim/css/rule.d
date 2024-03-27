module uim.css.rule;

import uim.css;
import std.algorithm.sorting;

@safe:

/// A single CSS rule with one or more selectors, and a declaration block.
class DCSSRule : DCSSObj {
	this() { super(); }
	this(string aSelector) { this().selector(aSelector); }
	this(string aSelector, string name, string value) { this(aSelector).declaration(name, value); }
	this(string aSelector, string[string] someDeclarations) { this(aSelector).declarations(someDeclarations); }

	override protected void _init() { super._init; }

	mixin(PropertyDefinition!("string", "selector"));
	version(test_uim_css) { unittest {
		assert(CSSRule("test") == `test{}`);
	}}

	string[string] _declarations;
	auto declarations(this O)(){ return _declarations; }
	O declarations(this O)(string[string] someDeclarations){ foreach(k, v; someDeclarations) this.declaration(k, v); return cast(DO)this;}

	string declaration(string name){ return _declarations[name]; }
	O declaration(this O)(string name, string value){ _declarations[name] = value; return cast(DO)this; }
	version(test_uim_css) { unittest {
		assert(CSSRule("test").declaration("do", "it") == `test{do:it}`);
		assert(CSSRule("body", ["background-color": "lightgreen"]) == "body{background-color:lightgreen}");
		assert(CSSRule("body", ["background-color": "lightgreen"]).declaration("border","0") == "body{background-color:lightgreen;border:0}");
	}}

	alias opEquals = Object.opEquals;
	bool opEquals(string css) { return toString == css; }
	bool opEquals(DCSSRule obj) { return toString == obj.toString; }

	override string toString() {
		string[] inner;
		foreach(k; _declarations.byKey().array.sort!("a < b")) inner ~= k~":"~_declarations[k];  
		return _selector~"{"~inner.join(";")~"}";
	}
}
auto CSSRule() { return new DCSSRule(); }
auto CSSRule(string selector) { return new DCSSRule(selector); }
auto CSSRule(string selector, string name, string value) { return new DCSSRule(selector, name, value); }
auto CSSRule(string selector, string[string] someDeclarations) { return new DCSSRule(selector, someDeclarations); }

version(test_uim_css) { unittest {
	assert(CSSRule("test") == `test{}`);
	assert(CSSRule("test").declaration("do", "it") == `test{do:it}`);
	assert(CSSRule("body", ["background-color": "lightgreen"]) == "body{background-color:lightgreen}");
	assert(CSSRule("body", ["background-color": "lightgreen"]).declaration("border","0") == "body{background-color:lightgreen;border:0}");
}}
