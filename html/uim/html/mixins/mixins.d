module uim.html.mixins.mixins;

import uim.html;
@safe:

template H5Calls(const char[] left, const char[] right = "") {
	const char[] r = (right.length > 0 ? right : "D"~left);
	const char[] H5Calls = "
auto "~left~"(string content) { return new "~r~"(content); }
auto "~left~"(DH5Obj[] content...) { return new "~r~"(content.dup); }
auto "~left~"(DH5Obj[] content) { return new "~r~"(content); }
auto "~left~"(DH5 content) { return new "~r~"(content); }

auto "~left~"(string id, DH5Obj[] content...) { return new "~r~"(id, content.dup); }
auto "~left~"(string id, DH5Obj[] content) { return new "~r~"(id, content); }
auto "~left~"(string id, DH5 content) { return new "~r~"(id, content); }

auto "~left~"(string id, string[] classes) { return new "~r~"(id, classes); }
auto "~left~"(string id, string[] classes, string content) { return new "~r~"(id, classes, content); }
auto "~left~"(string id, string[] classes, DH5Obj[] content...) { return new "~r~"(id, classes, content.dup); }
auto "~left~"(string id, string[] classes, DH5Obj[] content) { return new "~r~"(id, classes, content); }
auto "~left~"(string id, string[] classes, DH5 content) { return new "~r~"(id, classes, content); }

auto "~left~"(string id, STRINGAA attributes) { return new "~r~"(id, attributes); }
auto "~left~"(string id, STRINGAA attributes, string content) { return new "~r~"(id, attributes, content); }
auto "~left~"(string id, STRINGAA attributes, DH5Obj[] content...) { return new "~r~"(id, attributes, content.dup); }
auto "~left~"(string id, STRINGAA attributes, DH5Obj[] content) { return new "~r~"(id, attributes, content); }
auto "~left~"(string id, STRINGAA attributes, DH5 content) { return new "~r~"(id, attributes, content); }

auto "~left~"(string id, string[] classes, STRINGAA attributes) { return new "~r~"(id, classes, attributes); }
auto "~left~"(string id, string[] classes, STRINGAA attributes, string content) { return new "~r~"(id, classes, attributes, content); }
auto "~left~"(string id, string[] classes, STRINGAA attributes, DH5Obj[] content...) { return new "~r~"(id, classes, attributes, content.dup); }
auto "~left~"(string id, string[] classes, STRINGAA attributes, DH5Obj[] content) { return new "~r~"(id, classes, attributes, content); }
auto "~left~"(string id, string[] classes, STRINGAA attributes, DH5 content) { return new "~r~"(id, classes, attributes, content); }

auto "~left~"(string[] classes) { return new "~r~"(classes); }
auto "~left~"(string[] classes, string content) { return new "~r~"(classes, content); }
auto "~left~"(string[] classes, DH5Obj[] content...) { return new "~r~"(classes, content.dup); }
auto "~left~"(string[] classes, DH5Obj[] content) { return new "~r~"(classes, content); }
auto "~left~"(string[] classes, DH5 content) { return new "~r~"(classes, content); }

auto "~left~"(STRINGAA attributes) { return new "~r~"(attributes); }
auto "~left~"(STRINGAA attributes, string content) { return new "~r~"(attributes, content); }
auto "~left~"(STRINGAA attributes, DH5Obj[] content...) { return new "~r~"(attributes, content.dup); }
auto "~left~"(STRINGAA attributes, DH5Obj[] content) { return new "~r~"(attributes, content); }
auto "~left~"(STRINGAA attributes, DH5 content) { return new "~r~"(attributes, content); }

auto "~left~"(string[] classes, STRINGAA attributes) { return new "~r~"(classes, attributes); }
auto "~left~"(string[] classes, STRINGAA attributes, string content) { return new "~r~"(classes, attributes, content); }
auto "~left~"(string[] classes, STRINGAA attributes, DH5Obj[] content...) { return new "~r~"(classes, attributes, content.dup); }
auto "~left~"(string[] classes, STRINGAA attributes, DH5Obj[] content) { return new "~r~"(classes, attributes, content); }
auto "~left~"(string[] classes, STRINGAA attributes, DH5 content) { return new "~r~"(classes, attributes, content); }";
}

auto h5Methods(const char[] left, const char[] right) {
	return "
"~left~"(string content) { "~right~"(content); }
"~left~"(DH5Obj[] content...) { "~right~"(content.dup); }
"~left~"(DH5Obj[] content) { "~right~"(content); }
"~left~"(DH5 content) { "~right~"(content); }

"~left~"(string id, string content) { "~right~"(id, content); }
"~left~"(string id, DH5Obj[] content...) { "~right~"(id, content.dup); }
"~left~"(string id, DH5Obj[] content) { "~right~"(id, content); }
"~left~"(string id, DH5 content) { "~right~"(id, content); }

"~left~"(string id, string[] classes) { "~right~"(id, classes); }
"~left~"(string id, string[] classes, string content) { "~right~"(id, classes, content); }
"~left~"(string id, string[] classes, DH5Obj[] content...) { "~right~"(id, classes, content.dup); }
"~left~"(string id, string[] classes, DH5Obj[] content) { "~right~"(id, classes, content); }
"~left~"(string id, string[] classes, DH5 content) { "~right~"(id, classes, content); }

"~left~"(string id, STRINGAA attributes) { "~right~"(id, attributes); }
"~left~"(string id, STRINGAA attributes, string content) { "~right~"(id, attributes, content); }
"~left~"(string id, STRINGAA attributes, DH5Obj[] content...) { "~right~"(id, attributes, content.dup); }
"~left~"(string id, STRINGAA attributes, DH5Obj[] content) { "~right~"(id, attributes, content); }
"~left~"(string id, STRINGAA attributes, DH5 content) { "~right~"(id, attributes, content); }

"~left~"(string id, string[] classes, STRINGAA attributes) { "~right~"(id, classes, attributes); }
"~left~"(string id, string[] classes, STRINGAA attributes, string content) { "~right~"(id, classes, attributes, content); }
"~left~"(string id, string[] classes, STRINGAA attributes, DH5Obj[] content...) { "~right~"(id, classes, attributes, content.dup); }
"~left~"(string id, string[] classes, STRINGAA attributes, DH5Obj[] content) { "~right~"(id, classes, attributes, content); }
"~left~"(string id, string[] classes, STRINGAA attributes, DH5 content) { "~right~"(id, classes, attributes, content); }

"~left~"(string[] classes) { "~right~"(classes); }
"~left~"(string[] classes, string content) { "~right~"(classes, content); }
"~left~"(string[] classes, DH5Obj[] content...) { "~right~"(classes, content.dup); }
"~left~"(string[] classes, DH5Obj[] content) { "~right~"(classes, content); }
"~left~"(string[] classes, DH5 content) { "~right~"(classes, content); }

"~left~"(STRINGAA attributes) { "~right~"(attributes); }
"~left~"(STRINGAA attributes, string content) { "~right~"(attributes, content); }
"~left~"(STRINGAA attributes, DH5Obj[] content...) { "~right~"(attributes, content.dup); }
"~left~"(STRINGAA attributes, DH5Obj[] content) { "~right~"(attributes, content); }
"~left~"(STRINGAA attributes, DH5 content) { "~right~"(attributes, content); }

"~left~"(string[] classes, STRINGAA attributes) { "~right~"(classes, attributes); }
"~left~"(string[] classes, STRINGAA attributes, string content) { "~right~"(classes, attributes, content); }
"~left~"(string[] classes, STRINGAA attributes, DH5Obj[] content...) { "~right~"(classes, attributes, content.dup); }
"~left~"(string[] classes, STRINGAA attributes, DH5Obj[] content) { "~right~"(classes, attributes, content); }
"~left~"(string[] classes, STRINGAA attributes, DH5 content) { "~right~"(classes, attributes, content); }";
}

template H5This(string tag, string[] classes = null, string attributes = null, bool single = false) {
	const char[] strTag = (tag.length > 0) ? `this.tag("`~tag.toLower~`");` : "";
	const char[] strSingle = (single) ? "this.single(true);" : "";
	const char[] strClasses = (classes) ? "this.addClasses(["~classes.map!(a => `"`~a~`"`).join(",")~"]);" : "";
	const char[] strAttributes = (attributes) ? "this.addAttributes("~attributes~");" : "";
	const char[] initial = strTag~strSingle~strClasses~strAttributes;

	const char[] H5This = `
	this() { super(); `~initial~` }

	this(string someContent) 			{ this().addContent(someContent); }
	this(DH5Obj[] someContent...) { this().addContent(someContent.dup); }
	this(DH5Obj[] someContent) 		{ this().addContent(someContent); }
	this(DH5 someContent) 				{ this().addContent(someContent); }

	this(string[] someClasses) { this().addClasses(someClasses); }
	this(string[] someClasses, string someContent)      { this(someClasses).addContent(someContent); }
	this(string[] someClasses, DH5Obj[] someContent...) { this(someClasses).addContent(someContent.dup); }
	this(string[] someClasses, DH5Obj[] someContent)    { this(someClasses).addContent(someContent); }
	this(string[] someClasses, DH5 someContent)         { this(someClasses).addContent(someContent); }

 	this(STRINGAA someAttributes) { this().addAttributes(someAttributes); }
	this(STRINGAA someAttributes, string someContent)      { this(someAttributes).addContent(someContent); }
	this(STRINGAA someAttributes, DH5Obj[] someContent...) { this(someAttributes).addContent(someContent.dup); }
	this(STRINGAA someAttributes, DH5Obj[] someContent)    { this(someAttributes).addContent(someContent); }
	this(STRINGAA someAttributes, DH5 someContent)         { this(someAttributes).addContent(someContent); }

	this(string[] someClasses, STRINGAA someAttributes) { this(someClasses).addAttributes(someAttributes); }
	this(string[] someClasses, STRINGAA someAttributes, string someContent)      { this(someClasses, someAttributes).addContent(someContent); }
	this(string[] someClasses, STRINGAA someAttributes, DH5Obj[] someContent...) { this(someClasses, someAttributes).addContent(someContent.dup); }
	this(string[] someClasses, STRINGAA someAttributes, DH5Obj[] someContent)    { this(someClasses, someAttributes).addContent(someContent); }
	this(string[] someClasses, STRINGAA someAttributes, DH5 someContent)         { this(someClasses, someAttributes).addContent(someContent); }

	this(string id, string someContent) 		 { this().id(id).addContent(someContent); }
	this(string id, DH5Obj[] someContent...) { this().id(id).addContent(someContent.dup); }
	this(string id, DH5Obj[] someContent)    { this().id(id).addContent(someContent); }
	this(string id, DH5 someContent)         { this().id(id).addContent(someContent); }

	this(string id, string[] someClasses) { this(someClasses).id(id); }
	this(string id, string[] someClasses, string someContent)      { this(id, someClasses).addContent(someContent); }
	this(string id, string[] someClasses, DH5Obj[] someContent...) { this(id, someClasses).addContent(someContent.dup); }
	this(string id, string[] someClasses, DH5Obj[] someContent)    { this(id, someClasses).addContent(someContent); }
	this(string id, string[] someClasses, DH5 someContent)         { this(id, someClasses).addContent(someContent); }

	this(string id, STRINGAA someAttributes)  { this(someAttributes).id(id); }
	this(string id, STRINGAA someAttributes, string someContent)      { this(id, someAttributes).addContent(someContent); }
	this(string id, STRINGAA someAttributes, DH5Obj[] someContent...) { this(id, someAttributes).addContent(someContent.dup); }
	this(string id, STRINGAA someAttributes, DH5Obj[] someContent)    { this(id, someAttributes).addContent(someContent); }
	this(string id, STRINGAA someAttributes, DH5 someContent)         { this(id, someAttributes).addContent(someContent); }

	this(string id, string[] someClasses, STRINGAA someAttributes) { this(someClasses, someAttributes).id(id); }
	this(string id, string[] someClasses, STRINGAA someAttributes, string someContent)      { this(id, someClasses, someAttributes).addContent(someContent); }
	this(string id, string[] someClasses, STRINGAA someAttributes, DH5Obj[] someContent...) { this(id, someClasses, someAttributes).addContent(someContent.dup); }
	this(string id, string[] someClasses, STRINGAA someAttributes, DH5Obj[] someContent)    { this(id, someClasses, someAttributes).addContent(someContent); }
	this(string id, string[] someClasses, STRINGAA someAttributes, DH5 someContent)         { this(id, someClasses, someAttributes).addContent(someContent); }
	`;
}

template H5Short(string name) {	const char[] H5Short = h5Methods("auto H5"~name, "return new DH5"~name); }

template MyClassAttribute(string name, string clname = null) {
	const char[] cl = (clname) ? clname : name;
	const char[] MyClassAttribute = "
@property O "~name~"(this O)(bool value = true) { if (value) _classes = classes.add(\""~cl~"\"); else _classes = classes.sub(\""~cl~"\"); return cast(O)this; }
";
}

template classBoolean(string name, string clname = null) {
	const char[] cl = (clname.length > 0) ? clname : name;
	const char[] classBoolean = "
	bool _"~name~";
	@safe @property auto is"~name.capitalize~"() { return _"~name~"; }
	@safe @property O "~name~"(this O)(bool value = true) { _"~name~" = value; if (value) _classes = _classes.add(\""~cl~"\"); else _classes = _classes.sub(\""~cl~"\", true); return cast(O)this; }
";
}

template classString(string name) {
	const char[] classString = "
	string _"~name~";
	@safe @property auto "~name~"() { return _"~name~"; }
	@safe @property O "~name~"(this O)(string value) { _"~name~" = value; _classes = _classes.add(value); return cast(O)this; }
	@safe O remove"~name.capitalize~"(this O)(string value = _"~name~") { _classes = _classes.sub(_"~name~"); return cast(O)this; }
";
}

template classArray(string name) {
	const char[] classArray = "
	string[] _"~name~";
	@safe @property auto "~name~"() { return _"~name~"; }
	@safe @property O "~name~"(this O)(string[] values...) { _"~name~" ~= values; foreach(cl; values) _classes = _classes.add(cl); return cast(O)this; }
	@safe @property O "~name~"(this O)(string[] values) { _"~name~" ~= values; foreach(cl; values) _classes = _classes.add(cl); return cast(O)this; }
	@safe O remove"~name.capitalize~"(this O)(string[] values...) { foreach(cl; values) { _classes = _classes.sub(cl); _"~name~".sub(cl); } return cast(O)this; }
	@safe O remove"~name.capitalize~"(this O)(string[] values) { foreach(cl; values) { _classes = _classes.sub(cl); _"~name~".sub(cl); } return cast(O)this; }
";
}

template MyAttribute(string name, string h5name = null) {
	const char[] h5 = (h5name) ? h5name : name;
	const char[] MyAttribute = "
@safe @property string "~name~"() { return _attributes[\""~h5~"\"]; }
@safe @property O "~name~"(this O)(string value) { if (value.length > 0) _attributes[\""~h5~"\"] = value; return cast(O)this; }
@safe @property O "~name~"(this O)(bool value) { if (value) _attributes[\""~h5~"\"] = \"true\"; return cast(O)this; }
@safe @property O "~name~"(this O)(int value) { if (value) _attributes[\""~h5~"\"] = to!string(value); return cast(O)this; }
@safe @property O "~name~"(this O)(double value) { if (value) _attributes[\""~h5~"\"] = to!string(value); return cast(O)this; }
";
}

template AttributeBoolean(string name, string clname = null) {
	const char[] cl = (clname) ? clname : name;
	const char[] AttributeBoolean = `
	@safe @property auto is`~name.capitalize~`( { return ("`~cl~`" in _attributes); }
	@safe @property O `~name~`(this O)(bool value = true) { if (value) _attributes["`~cl~`"]= "`~cl~`"; else _attributes.remove("`~cl~`"); return cast(O)this; }
`;
}

template AttributeString(string name) {
	const char[] AttributeString = `
	@safe @property auto `~name~`() { return ("`~name~`" in _attributes ? _attributes["`~name~`"] : null); }
	@safe @property O `~name~`(this O)(string value) { if (value) _attributes["`~name~`"] = value; else _attributes.remove("`~name~`"); return cast(O)this; }
`;
}

auto h5Content(const char[] name, const char[] middle, const char[] right) {
	return "
O "~name~"(this O)() { "~middle~"("~right~"()); return cast(O)this; }

O "~name~"(this O)(string content) { "~middle~"("~right~"(content)); return cast(O)this; }
O "~name~"(this O)(DH5Obj[] content...) { "~middle~"("~right~"(content.dup)); return cast(O)this; }
O "~name~"(this O)(DH5Obj[] content) { "~middle~"("~right~"(content)); return cast(O)this; }
O "~name~"(this O)(DH5 content) { "~middle~"("~right~"(content)); return cast(O)this; }

O "~name~"(this O)(string id, string content) { "~middle~"("~right~"(id, content)); return cast(O)this; }
O "~name~"(this O)(string id, DH5Obj[] content...) { "~middle~"("~right~"(id, content.dup)); return cast(O)this; }
O "~name~"(this O)(string id, DH5Obj[] content) { "~middle~"("~right~"(id, content)); return cast(O)this; }
O "~name~"(this O)(string id, DH5 content) { "~middle~"("~right~"(id, content)); return cast(O)this; }

O "~name~"(this O)(string id, string[] classes) { "~middle~"("~right~"(id, classes)); return cast(O)this; }
O "~name~"(this O)(string id, string[] classes, string content) { "~middle~"("~right~"(id, classes, content)); return cast(O)this; }
O "~name~"(this O)(string id, string[] classes, DH5Obj[] content...) { "~middle~"("~right~"(id, classes, content.dup)); return cast(O)this; }
O "~name~"(this O)(string id, string[] classes, DH5Obj[] content) { "~middle~"("~right~"(id, classes, content)); return cast(O)this; }
O "~name~"(this O)(string id, string[] classes, DH5 content) { "~middle~"("~right~"(id, classes, content)); return cast(O)this; }

O "~name~"(this O)(string id, STRINGAA attributes) { "~middle~"("~right~"(id, attributes)); return cast(O)this; }
O "~name~"(this O)(string id, STRINGAA attributes, string content) { "~middle~"("~right~"(id, attributes, content)); return cast(O)this; }
O "~name~"(this O)(string id, STRINGAA attributes, DH5Obj[] content...) { "~middle~"("~right~"(id, attributes, content.dup)); return cast(O)this; }
O "~name~"(this O)(string id, STRINGAA attributes, DH5Obj[] content) { "~middle~"("~right~"(id, attributes, content)); return cast(O)this; }
O "~name~"(this O)(string id, STRINGAA attributes, DH5 content) { "~middle~"("~right~"(id, attributes, content)); return cast(O)this; }

O "~name~"(this O)(string id, string[] classes, STRINGAA attributes) { "~middle~"("~right~"(id, classes, attributes)); return cast(O)this; }
O "~name~"(this O)(string id, string[] classes, STRINGAA attributes, string content) { "~middle~"("~right~"(id, classes, attributes, content)); return cast(O)this; }
O "~name~"(this O)(string id, string[] classes, STRINGAA attributes, DH5Obj[] content...) { "~middle~"("~right~"(id, classes, attributes, content.dup)); return cast(O)this; }
O "~name~"(this O)(string id, string[] classes, STRINGAA attributes, DH5Obj[] content) { "~middle~"("~right~"(id, classes, attributes, content)); return cast(O)this; }
O "~name~"(this O)(string id, string[] classes, STRINGAA attributes, DH5 content) { "~middle~"("~right~"(id, classes, attributes, content)); return cast(O)this; }

O "~name~"(this O)(string[] classes) { "~middle~"("~right~"(classes)); return cast(O)this; }
O "~name~"(this O)(string[] classes, string content) { "~middle~"("~right~"(classes, content)); return cast(O)this; }
O "~name~"(this O)(string[] classes, DH5Obj[] content...) { "~middle~"("~right~"(classes, content.dup)); return cast(O)this; }
O "~name~"(this O)(string[] classes, DH5Obj[] content) { "~middle~"("~right~"(classes, content)); return cast(O)this; }
O "~name~"(this O)(string[] classes, DH5 content) { "~middle~"("~right~"(classes, content)); return cast(O)this; }

O "~name~"(this O)(STRINGAA attributes) { "~middle~"("~right~"(attributes)); return cast(O)this; }
O "~name~"(this O)(STRINGAA attributes, string content) { "~middle~"("~right~"(attributes, content)); return cast(O)this; }
O "~name~"(this O)(STRINGAA attributes, DH5Obj[] content...) { "~middle~"("~right~"(attributes, content.dup)); return cast(O)this; }
O "~name~"(this O)(STRINGAA attributes, DH5Obj[] content) { "~middle~"("~right~"(attributes, content)); return cast(O)this; }
O "~name~"(this O)(STRINGAA attributes, DH5 content) { "~middle~"("~right~"(attributes, content)); return cast(O)this; }

O "~name~"(this O)(string[] classes, STRINGAA attributes) { "~middle~"("~right~"(classes, attributes)); return cast(O)this; }
O "~name~"(this O)(string[] classes, STRINGAA attributes, string content) { "~middle~"("~right~"(classes, attributes, content)); return cast(O)this; }
O "~name~"(this O)(string[] classes, STRINGAA attributes, DH5Obj[] content...) { "~middle~"("~right~"(classes, attributes, content.dup)); return cast(O)this; }
O "~name~"(this O)(string[] classes, STRINGAA attributes, DH5Obj[] content) { "~middle~"("~right~"(classes, attributes, content)); return cast(O)this; }
O "~name~"(this O)(string[] classes, STRINGAA attributes, DH5 content) { "~middle~"("~right~"(classes, attributes, content)); return cast(O)this; }
 ";
}

template MyContent(string name, string className) {	
	const char[] MyContent = h5Content(name, "this.addContent", className); }
template MyContent(string name, string middle, string className) {	
	const char[] MyContent = h5Content(name, middle, className); }

template MyH5Obj(string className, string name) {		
	const char[] MyH5Obj = "
"~className~" _"~name~";
"~className~" "~name~"() { return _"~name~"; }

O "~name~"(this O)("~className~" obj) { _"~name~" = obj; return cast(O)this; }

O "~name~"(this O)(DH5Obj[] content...) { _"~name~" = new "~className~"(content); return cast(O)this; }
O "~name~"(this O)(DH5Obj[] content) { _"~name~" = new "~className~"(content); return cast(O)this; }
O "~name~"(this O)(DH5 content) { _"~name~" = new "~className~"(content); return cast(O)this; }

O "~name~"(this O)(string id) { _"~name~" = new "~className~"(id); return cast(O)this; }
O "~name~"(this O)(string id, string content) { _"~name~" = new "~className~"(id, content); return cast(O)this; }
O "~name~"(this O)(string id, DH5Obj[] content...) { _"~name~" = new "~className~"(id, content); return cast(O)this; }
O "~name~"(this O)(string id, DH5Obj[] content) { _"~name~" = new "~className~"(id, content); return cast(O)this; }
O "~name~"(this O)(string id, DH5 content) { _"~name~" = new "~className~"(id, content); return cast(O)this; }

O "~name~"(this O)(string id, string[] classes) { _"~name~" = new "~className~"(id, classes); return cast(O)this; }
O "~name~"(this O)(string id, string[] classes, string content) { _"~name~" = new "~className~"(id, classes, content); return cast(O)this; }
O "~name~"(this O)(string id, string[] classes, DH5Obj[] content...) { _"~name~" = new "~className~"(id, classes, content); return cast(O)this; }
O "~name~"(this O)(string id, string[] classes, DH5Obj[] content) { _"~name~" = new "~className~"(id, classes, content); return cast(O)this; }
O "~name~"(this O)(string id, string[] classes, DH5 content) { _"~name~" = new "~className~"(id, classes, content); return cast(O)this; }

O "~name~"(this O)(string id, STRINGAA attributes) { _"~name~" = new "~className~"(id, attributes); return cast(O)this; }
O "~name~"(this O)(string id, STRINGAA attributes, string content) { _"~name~" = new "~className~"(id, attributes, content); return cast(O)this; }
O "~name~"(this O)(string id, STRINGAA attributes, DH5Obj[] content...) { _"~name~" = new "~className~"(id, attributes, content); return cast(O)this; }
O "~name~"(this O)(string id, STRINGAA attributes, DH5Obj[] content) { _"~name~" = new "~className~"(id, attributes, content); return cast(O)this; }
O "~name~"(this O)(string id, STRINGAA attributes, DH5 content) { _"~name~" = new "~className~"(id, attributes, content); return cast(O)this; }

O "~name~"(this O)(string id, string[] classes, STRINGAA attributes) { _"~name~" = new "~className~"(id, classes, attributes); return cast(O)this; }
O "~name~"(this O)(string id, string[] classes, STRINGAA attributes, string content) { _"~name~" = new "~className~"(id, classes, attributes, content); return cast(O)this; }
O "~name~"(this O)(string id, string[] classes, STRINGAA attributes, DH5Obj[] content...) { _"~name~" = new "~className~"(id, classes, attributes, content); return cast(O)this; }
O "~name~"(this O)(string id, string[] classes, STRINGAA attributes, DH5Obj[] content) { _"~name~" = new "~className~"(id, classes, attributes, content); return cast(O)this; }
O "~name~"(this O)(string id, string[] classes, STRINGAA attributes, DH5 content) { _"~name~" = new "~className~"(id, classes, attributes, content); return cast(O)this; }

O "~name~"(this O)(string[] classes) { _"~name~" = new "~className~"(classes); return cast(O)this; }
O "~name~"(this O)(string[] classes, string content) { _"~name~" = new "~className~"(classes, content); return cast(O)this; }
O "~name~"(this O)(string[] classes, DH5Obj[] content...) { _"~name~" = new "~className~"(classes, content); return cast(O)this; }
O "~name~"(this O)(string[] classes, DH5Obj[] content) { _"~name~" = new "~className~"(classes, content); return cast(O)this; }
O "~name~"(this O)(string[] classes, DH5 content) { _"~name~" = new "~className~"(classes, content); return cast(O)this; }

O "~name~"(this O)(STRINGAA attributes) { _"~name~" = new "~className~"(attributes); return cast(O)this; }
O "~name~"(this O)(STRINGAA attributes, string content) { _"~name~" = new "~className~"(attributes, content); return cast(O)this; }
O "~name~"(this O)(STRINGAA attributes, DH5Obj[] content...) { _"~name~" = new "~className~"(attributes, content); return cast(O)this; }
O "~name~"(this O)(STRINGAA attributes, DH5Obj[] content) { _"~name~" = new "~className~"(attributes, content); return cast(O)this; }
O "~name~"(this O)(STRINGAA attributes, DH5 content) { _"~name~" = new "~className~"(attributes, content); return cast(O)this; }

O "~name~"(this O)(string[] classes, STRINGAA attributes) { _"~name~" = new "~className~"(classes, attributes); return cast(O)this; }
O "~name~"(this O)(string[] classes, STRINGAA attributes, string content) { _"~name~" = new "~className~"(classes, attributes, content); return cast(O)this; }
O "~name~"(this O)(string[] classes, STRINGAA attributes, DH5Obj[] content...) { _"~name~" = new "~className~"(classes, attributes, content); return cast(O)this; }
O "~name~"(this O)(string[] classes, STRINGAA attributes, DH5Obj[] content) { _"~name~" = new "~className~"(classes, attributes, content); return cast(O)this; }
O "~name~"(this O)(string[] classes, STRINGAA attributes, DH5 content) { _"~name~" = new "~className~"(classes, attributes, content); return cast(O)this; }
";
}

