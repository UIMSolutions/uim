module uim.html.elements.wbr;

@safe:
import uim.html;

class DH5Wbr : DH5Obj {
	mixin(H5This!"wbr");
}
mixin(H5Short!"Wbr");

version(test_uim_html) { unittest {
	testH5Obj(H5Wbr, "wbr");
}}
