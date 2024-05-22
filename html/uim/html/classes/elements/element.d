module uim.html.classes.elements.element;

@safe:
import uim.html;

class DH5Element : DH5Obj {
	mixin(H5This!"element");
}
mixin(H5Short!"Element");

version(test_uim_html) { unittest {
	assert(H5Element, "element");
}}