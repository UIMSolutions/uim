module uim.html.elements.tfoot;

@safe:
import uim.html;

class DH5Tfoot : DH5Obj {
	mixin(H5This!"tfoot");

	// Adding a row <tr>
	mixin(MyContent!("tr", "H5Tr"));
	// Adding a row <tr>
	mixin(MyContent!("row", "H5Tr"));
}
mixin(H5Short!"Tfoot");

version(test_uim_html) { unittest {
	testH5Obj(H5Tfoot, "tfoot");
	assert(H5Tfoot.tr == "<tfoot><tr></tr></tfoot>");
	assert(H5Tfoot.row == "<tfoot><tr></tr></tfoot>");
	assert(H5Tfoot.tr.tr == "<tfoot><tr></tr><tr></tr></tfoot>");
	assert(H5Tfoot.row.row == "<tfoot><tr></tr><tr></tr></tfoot>");
	assert(H5Tfoot.tr.row == "<tfoot><tr></tr><tr></tr></tfoot>");
	assert(H5Tfoot.row.tr == "<tfoot><tr></tr><tr></tr></tfoot>");
}}
