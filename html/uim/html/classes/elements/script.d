﻿module uim.html.classes.elements.script;

import uim.html;
@safe:

class DH5Script : DH5Obj {
	mixin(H5This!"script");

	override string renderJS(string[string] bindings = null) {
		return null;
	}
}
mixin(H5Short!"Script");

version(test_uim_html) { unittest {
  assert(H5Script == "<script></script>");
}}

string toString(DH5Script[] scripts) {
	return scripts.map!(s => s.toString).join;
}
version(test_uim_html) { unittest {
    // assert([H5Script, H5Script].toString == "<script></script><script></script>");
}}

DH5Script[] H5Scripts(string[string][] scripts...) { 
	return H5Scripts(scripts.dup); 
}

DH5Script[] H5Scripts(string[string][] scripts) { 
	return scripts.map!(s => H5Script(s)).array;
}
version(test_uim_html) { unittest {
		// TODO
}}
