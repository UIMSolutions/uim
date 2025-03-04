module uim.html.classes.elements.ol;

import uim.html;
@safe:

class DH5Ol : DH5Obj {
	mixin(H5This!"ol");

	mixin(MyContent!("item", "H5Li"));
	version(test_uim_html) { unittest {
		assert(H5Ol.item == "<ol><li></li></ol>");
	}}
}
mixin(H5Short!"Ol");
version(test_uim_html) { unittest {
  testH5Obj(H5Ol, "ol");
}}
