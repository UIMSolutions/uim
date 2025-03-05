module uim.html.classes.elements.span;

import uim.html;
@safe:

class DH5Span : DH5Obj {
	mixin(H5This!"Span");
}
mixin(H5Short!"Span");

version(test_uim_html) { unittest {	
	assert(H5Span == "<span></span>");
}}
