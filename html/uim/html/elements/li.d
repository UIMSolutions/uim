module uim.html.elements.li;

@safe:
import uim.html;

// Wrapper for <li> - represent an item in a list.
class DH5Li : DH5Obj {
	mixin(H5This!"li");
}
mixin(H5Short!"Li");

version(test_uim_html) { unittest {
  testH5Obj(H5Li, "li");
}}
