module uim.html.classes.elements.del;

import uim.html;
@safe:

class DH5Del : DH5Obj {
	mixin(H5This!"del");
}
mixin(H5Short!"Del");

version(test_uim_html) { unittest {
  testH5Obj(H5Del, "del");
}}
