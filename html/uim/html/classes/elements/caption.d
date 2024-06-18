module uim.html.classes.elements.caption;

import uim.html;
@safe:

// Wrapper for caption tag = specifies the caption (or title) of a table. 
class DH5Caption : DH5Obj {
	mixin(H5This!"caption");
}
mixin(H5Short!"Caption");

version(test_uim_html) { unittest {
  assert(H5Caption == "<caption></caption>");
}}
