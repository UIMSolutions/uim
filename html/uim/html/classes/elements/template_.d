module uim.html.elements.template_;

@safe:
import uim.html;

// Wrapper for <template> - s a mechanism for holding HTML that is not to be rendered immediately when a page is loaded but may be instantiated subsequently during runtime using JavaScript.
class DH5Template : DH5Obj {
	mixin(H5This!"template");
}
mixin(H5Short!"Template");

version(test_uim_html) { unittest {
    assert(H5Template == "<template></template>");
}}
