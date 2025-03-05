module uim.html.classes.elements.sup;

import uim.html;
@safe:

// Wrapper for <sup> - specifies inline text which is to be displayed as superscript for solely typographical reasons. 
class DH5Sup : DH5Obj {
	mixin(H5This!"sup");
}
mixin(H5Short!"Sup");

version(test_uim_html) { unittest {
    assert(H5Sup == "<sup></sup>");
}}
