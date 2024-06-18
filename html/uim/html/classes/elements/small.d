module uim.html.classes.elements.small;

import uim.html;
@safe:

// Wrapper for <small> - represents side-comments and small print, like copyright and legal text, independent of its styled presentation.
class DH5Small : DH5Obj {
	mixin(H5This!"small");
}
mixin(H5Short!"Small");

version(test_uim_html) { unittest {
    testH5Obj(H5Small, "small");
}}

