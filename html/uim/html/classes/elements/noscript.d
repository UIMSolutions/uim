module uim.html.classes.elements.noscript;

@safe:
import uim.html;

class DH5Noscript : DH5Obj {
	mixin(H5This!("noscript"));
}
mixin(H5Short!"Noscript");

version(test_uim_html) { unittest {
    assert(H5Noscript == "<noscript></noscript>");
}}
