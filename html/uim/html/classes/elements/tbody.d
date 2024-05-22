module uim.html.classes.elements.tbody;

@safe:
import uim.html;

class DH5Tbody : DH5Obj {
	mixin(H5This!"tbody");
	
	mixin(MyContent!("tr", "H5Tr"));
	version(test_uim_html) { unittest {
			assert(H5Tbody.tr == "<tbody><tr></tr></tbody>");
	}}

	mixin(MyContent!("row", "H5Tr"));
	version(test_uim_html) { unittest {
			assert(H5Tbody.row == "<tbody><tr></tr></tbody>");
	}}
}
mixin(H5Short!"Tbody");
version(test_uim_html) { unittest {
    assert(H5Tbody == "<tbody></tbody>");
}}
