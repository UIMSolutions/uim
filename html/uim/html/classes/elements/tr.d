module uim.html.classes.elements.tr;

import uim.html;
@safe:

class DH5Tr : DH5Obj {
	mixin(H5This!"tr");

	mixin(MyContent!("th", "H5Th"));
	version(test_uim_html) { unittest {
			assert(H5Tr.th, "<tr><th></th></tr>");
	}}

	mixin(MyContent!("td", "H5Td"));
	mixin(MyContent!("cell", "H5Td"));
}
mixin(H5Calls!("H5Tr", "DH5Tr"));

version(test_uim_html) { unittest {
    testH5Obj(H5Tr, "tr");
		assert(H5Tr.td == "<tr><td></td></tr>");
		assert(H5Tr.cell == "<tr><td></td></tr>");
		assert(H5Tr(H5Td) == "<tr><td></td></tr>");
		assert(H5Tr(H5Td, H5Td) == "<tr><td></td><td></td></tr>");
		assert(H5Tr.td == "<tr><td></td></tr>");
		assert(H5Tr.cell == "<tr><td></td></tr>");
		assert(H5Tr.td.td == "<tr><td></td><td></td></tr>");
		assert(H5Tr.cell.cell == "<tr><td></td><td></td></tr>");
}}
