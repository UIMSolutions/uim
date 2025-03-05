module uim.html.classes.elements.colgroup;

import uim.html;
@safe:

class DH5Colgroup : DH5Obj {
	mixin(H5This!"Colgroup");
}
mixin(H5Short!"Colgroup");

version(test_uim_html) { unittest {
  testH5Obj(H5Colgroup, "colgroup");
}}
