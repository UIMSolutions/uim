module uim.html.classes.elements.embed;

import uim.html;
@safe:

class DH5Embed : DH5Obj {
	mixin(H5This!"embed");
}
mixin(H5Short!"Embed");

version(test_uim_html) { unittest {
  testH5Obj(H5Embed, "embed");
}}
