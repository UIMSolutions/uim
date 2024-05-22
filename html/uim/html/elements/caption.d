module uim.html.elements.caption;

@safe:
import uim.html;

// Wrapper for caption tag = specifies the caption (or title) of a table. 
class DH5Caption : DH5Obj {
	mixin(H5This!"caption");
}
mixin(H5Short!"Caption");

version(test_uim_html) { unittest {
  assert(H5Caption == "<caption></caption>");
}}
