module uim.html.elements.rp;

@safe:
import uim.html;

class DH5Rp : DH5Obj {
	mixin(H5This!"rp");
}
mixin(H5Short!"Rp");

version(test_uim_html) { unittest {
    assert(H5Rp == "<rp></rp>");
}}