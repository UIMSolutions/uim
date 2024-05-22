module uim.html.elements.s;

@safe:
import uim.html; 

class DH5S : DH5Obj {
	mixin(H5This!"s");
}
mixin(H5Short!"S");

version(test_uim_html) { unittest {
    testH5Obj(H5S, "s");
}}
