module uim.html.classes.elements.table;

@safe:
import uim.html;

class DH5Table : DH5Obj {
	mixin(H5This!"table");

	mixin(MyContent!("header", "H5Thead"));
	version(test_uim_html) { unittest {
		assert(H5Table.header, "<table><thead></thead></table>");
	}}

	mixin(MyContent!("body_", "H5Tbody"));
	version(test_uim_html) { unittest {
		assert(H5Table.body_, "<table><tbody></tbody></table>");
	}}

	mixin(MyContent!("footer", "H5Tfoot"));
	version(test_uim_html) { unittest {
		assert(H5Table.footer, "<table><tfoot></tfoot></table>");
	}}

	mixin(MyContent!("tr", "H5Tr"));
	version(test_uim_html) { unittest {
		assert(H5Table.tr, "<table><tr></tr></table>");
	}}

	mixin(MyContent!("row", "H5Tr"));
	version(test_uim_html) { unittest {
		assert(H5Table.row, "<table><tr></tr></table>");
	}}

	mixin(MyContent!("colgroup", "H5Colgroup"));
	version(test_uim_html) { unittest {
		assert(H5Table.colgroup, "<table><colgroup></colgroup></table>");
	}}

	mixin(MyContent!("caption", "H5Caption"));
	version(test_uim_html) { unittest {  
		assert(H5Table.caption, "<table><caption></caption></table>");
	}}
}
mixin(H5Short!"Table");
version(test_uim_html) { unittest {
    assert(H5Table == "<table></table>");
}}
