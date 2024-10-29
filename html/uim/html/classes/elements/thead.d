module uim.html.classes.elements.thead;

import uim.html;
@safe:

class DH5Thead : DH5Obj {
	mixin(H5This!"thead");

	mixin(MyContent!("tr", "H5Tr"));
	mixin(MyContent!("row", "H5Tr"));
}
mixin(H5Short!"Thead");

version(test_uim_html) { unittest {
  testH5Obj(H5Thead, "thead");
	assert(H5Thead.tr == "<thead><tr></tr></thead>");
	assert(H5Thead.row == "<thead><tr></tr></thead>");
}}
