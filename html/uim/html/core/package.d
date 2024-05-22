module uim.html.core;

public import std.stdio;
public import std.conv;
public import std.array;
public import std.string;
public import std.random;
public import std.traits;
public import std.algorithm.iteration;	

public import uim.html;

public import uim.html.core.element;
public import uim.html.core.html;

template sTag(string fName, string tName, string overRide = "") {
	const char[] dTag = "	
	 "~overRide~" DH5Root "~fName~"(STRINGAA values) { html.addSTag(\""~tName~"\", values); return this; }
";
}
template dTag(string fName, string tName, string overRide = "") {
	const char[] dTag = "	
	 "~overRide~" DH5Root "~fName~"(STRINGAA values) { html.addDTag(\""~tName~"\", values); return this; }
	 "~overRide~" DH5Root "~fName~"(T)(T[] contents...) { html.addDTag(\""~tName~"\", contents); return this; }
	 "~overRide~" DH5Root "~fName~"(T)(STRINGAA values, T[] contents...) { html.addDTag(\""~tName~"\", values, contents); return this; }
";
}

version(test_uim_html) { unittest {
		// TODO Add Test
		}}