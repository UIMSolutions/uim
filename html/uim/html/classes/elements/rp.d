module uim.html.classes.elements.rp;

import uim.html;
@safe:

class DH5Rp : DH5Obj {
	mixin(H5This!"rp");
}
mixin(H5Short!"Rp");

version(test_uim_html) { unittest {
    assert(H5Rp == "<rp></rp>");
}}