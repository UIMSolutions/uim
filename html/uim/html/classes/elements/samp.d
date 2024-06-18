module uim.html.classes.elements.samp;

import uim.html;
@safe:

class DH5Samp : DH5Obj {
	mixin(H5This!"samp");
}
mixin(H5Short!"Samp");

version(test_uim_html) { unittest {
    assert(H5Samp,"<samp></samp>");
}}
