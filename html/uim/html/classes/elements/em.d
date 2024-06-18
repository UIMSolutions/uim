module uim.html.classes.elements.em;

import uim.html;
@safe:

class DH5Em: DH5Obj {
	mixin(H5This!"em");
}
mixin(H5Short!"Em");

version(test_uim_html) { unittest {
  testH5Obj(H5Em, "em");
}}