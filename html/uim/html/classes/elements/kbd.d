module uim.html.classes.elements.kbd;

import uim.html;
@safe:

class DH5Kbd : DH5Obj {
	mixin(H5This!"kbd");
}
mixin(H5Short!"Kbd");

version(test_uim_html) { unittest {
  testH5Obj(H5Kbd, "kbd");
}}
