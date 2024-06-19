module uim.html.core;

public {
	import uim.html.core.html;
}

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
