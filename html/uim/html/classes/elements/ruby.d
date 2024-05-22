module uim.html.elements.ruby;

import uim.html; 

class DH5Ruby : DH5Obj {
	mixin(H5This!"ruby");
}
mixin(H5Short!"Ruby");

version(test_uim_html) { unittest {
    testH5Obj(H5Ruby, "ruby");
}}
