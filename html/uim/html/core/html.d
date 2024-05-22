module uim.html.core.html;

@safe:
import uim.html;

template sTag(string fName) {
	const char[] sTag = "	
	  DHTML "~fName~"(STRINGAA values) { return addSTag("~fName~", values); }
";
}

template dTag(string fName) {
	const char[] dTag = "	
	 DHTML "~fName~"(T)(T[] content...) { return addDTag("~fName~", contents); }
	 DHTML "~fName~"(STRINGAA values) { return addDTag("~fName~", values); }
	 DHTML "~fName~"(T)(STRINGAA values, T[] contents...) { return addDTag("~fName~", values, contents); }
";
}

template STag(string fName, string tName) {
	const char[] STag = "	
 auto "~fName~"() { addS(\""~tName~"\"); return this; }
 auto "~fName~"(STRINGAA values) { addS(\""~tName~"\", values); return this; }
";
}

template DTag(string fName, string tName) {
	const char[] DTag = "	
 auto "~fName~"(string content) { addD(\""~tName~"\", content); return this; }
 auto "~fName~"(DOPObject content) { addD(\""~tName~"\", content); return this; }
 auto "~fName~"(STRINGAA values) { addD(\""~tName~"\", values); return this; }
 auto "~fName~"(STRINGAA values, string content) { addD(\""~tName~"\", values, content); return this; }
 auto "~fName~"(STRINGAA values, DOPObject content) { addD(\""~tName~"\", values, content); return this; }
 auto "~fName~"(STRINGAA values, string[] content) { addD(\""~tName~"\", values, content); return this; }
 auto "~fName~"(STRINGAA values, DOPObject[] content) { addD(\""~tName~"\", values, content); return this; }
";
}

//class DHTML {
//	DHTML listener;
//	static DHTML opCall(T...)(T values) { return new DHTML(values); }
//	O opCall(this O, T...)(T values) { foreach(v; values) add(v); return cast(O)this; } 
//	O opCall(this O)(string value) { add(value); return cast(O)this; } 
//	O opCall(this O)(DOPObject value) { add(value); return cast(O)this; } 
//
//	this(T...)(T values) { this(); add(values); }
//	this() { listener = this;}
//	// this(DHTML aListener ) { listener = aListener; }
////	this(string entry) { this(); add(entry); }
//	// this(string[] entries...) { this(); add(entries); }
////	this(DOPObject entry) { this(); add(entry); }
////	this(DOPObject[] entries...) { this(); add(entries); }
//
////	void Add(T...)(T values) { foreach(v; values) Add(v); }
////	void Add(T)(T[] values) { foreach(v; values) Add(v); }
////	void Add(T)(T value) { add(v); }
//
////	alias add = super.add;
////	void add(string value) { if (value) add(String(value)); }
////	void add(string[] values) { foreach(value; values) add(String(value)); }
////	override void add(DOPObject value) { if (value) _objects ~= value; }
//
////	void addS(string tag) { add("<%s/>".format(tag)); }
////	void addS(string tag, STRINGAA attributes) { add("<%s%s/>".format(tag, attributes.toString)); }
//
////	void addD(string tag) { add(doubleTag(tag)); }
//////	void addD(string tag, DOPObject[] objs...) { 
////		string result;
////		foreach(c; objs) result ~= c.toString;
////		//add(tag, result);
////	}
////	void addD(string tag, string[] contents...) { addD(tag, contents.join("")); }
////	void addD(string tag, string content) { add(doubleTag(tag, content)); }
////	void addD(string tag, DOPObject content) { add(doubleTag(tag, content.toString));  }
//
////	void addD(string tag, STRINGAA attributes) { add(doubleTag(tag, attributes)); }
//////	void addD(string tag, STRINGAA attributes, DOPObject[] contents...) { 
////		string result;
////		foreach(c; contents) result ~= c.toString;
////		addD(tag, attributes, result);
////	}
////	void addD(string tag, STRINGAA attributes, string[] contents...) { addD(tag, attributes, contents.join("")); }
////	void addD(string tag, STRINGAA attributes, string content) { addD(tag, attributes, content); }
////	void addD(string tag, STRINGAA attributes, DOPObject content) { addD(tag, attributes, content.toString);  }
//
////	string attsToString(STRINGAA atts) {
////		string[] strings;
////		foreach(k, v; atts) strings ~= `%s="%s"`.format(k, v);
////		return strings.join(" ");
////	}
////	auto startTag(string tag, STRINGAA attributes = null) {
////		if (attributes) 
////			return add("<"~tag~" "~aa2String(attributes)~">");
////		else 
////			return add("<"~tag~">");
////	}
////	auto simpleTag(string tag, STRINGAA attributes = null) {
////		if (attributes) 
////			return add("<"~tag~" "~aa2String(attributes)~"/>");
////		else 
////			return add("<"~tag~"/>");
////	}
////	auto endTag(string tag) { return add("</"~tag~">"); }
//
////	auto head(T)(T content) { return addD("HEAD", content); }
////	auto head(STRINGAA values) { return addD("HEAD", values); }
////	auto head(T)(STRINGAA values, T content) { return addDTag("HEAD", values, content); }
////
////	auto doctype() {return add("<!DOCTYPE html>"); }
////	auto meta(STRINGAA values) { return addS("META", values); }
////	auto base(STRINGAA values) { return addS("BASE", values); }
////	auto link(STRINGAA values) { return addS("LINK", values); }
////	auto style(T)(T content) { return addD("STYLE", content.toString); }
////	auto style(T:STRINGAA)(T values) { return addD("STYLE", values); }
////	auto style(T)(STRINGAA values, T content) { return addD("STYLE", values, content.toString); }
////	auto style(T:DCSS)(T content) { return addD("STYLE", content.toString); }
//
////	mixin(DTag!("script", "Script"));
////	mixin(DTag!("bdy", "BODY"));
//
//	//	mixin(dTag!("div"));
//	//	mixin(dTag!("h1"));
//	//	mixin(dTag!("h2"));
//	//	mixin(dTag!("h3"));
//	//	mixin(dTag!("h4"));
//	//	mixin(dTag!("h5"));
//	//	mixin(dTag!("h6"));
//	//	mixin(dTag!("p"));
//	//	mixin(dTag!("span"));
//	//	mixin(dTag!("table"));
//	//	mixin(dTag!("canvas", "CANVAS"));
////	auto canvas(string id, string width, string height) { return addD("CANVAS", ["id": id, "width": width, "height": height]); }
////	auto canvas(STRINGAA attributes, string id, string width, string height) { 
////		auto atts = attributes;
////		atts["id"] = id;
////		atts["width"] = width;
////		atts["height"] = height;
////		return addD("CANVAS", atts); }
//}
//

version(test_uim_html) { unittest {
		// TODO Add Test
}}