module uim.html.classes.elements.u;

import uim.html;
@safe:

class DH5U : DH5Obj {
	mixin(H5This!"u");
}
mixin(H5Short!"U");

version(test_uim_html) { unittest {
   testH5Obj(H5U, "u");
}}
