module uim.html.classes.elements.p;

import uim.html;
@safe:

class DH5P : DH5Obj {
	mixin(H5This!("P"));
}
mixin(H5Short!"P");

version(test_uim_html) { unittest {
    assert(H5P == "<p></p>");
}}