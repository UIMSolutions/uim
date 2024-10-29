module uim.html.classes.elements.wbr;

import uim.html;
@safe:

class DH5Wbr : DH5Obj {
	mixin(H5This!"wbr");
}
mixin(H5Short!"Wbr");

version(test_uim_html) { unittest {
	testH5Obj(H5Wbr, "wbr");
}}
