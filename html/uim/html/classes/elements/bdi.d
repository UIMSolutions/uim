module uim.html.classes.elements.bdi;

@safe:
import uim.html;

// Wrapper for bdi tag - tells the browser's bidirectional algorithm to treat the text it contains in isolation from its surrounding text.
class DH5Bdi : DH5Obj {
	mixin(H5This!"bdi");
}
mixin(H5Short!"Bdi");

version(test_uim_html) { unittest {
	testH5Obj(H5Bdi, "bdi");
}}

