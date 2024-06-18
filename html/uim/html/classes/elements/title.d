module uim.html.classes.elements.title;

import uim.html;
@safe:

class DH5Title : DH5Obj {
	mixin(H5This!("title"));
}
mixin(H5Short!"Title");

version(test_uim_html) { unittest {
  testH5Obj(H5Title, "title");
  // mixin(testH5DoubleClasses!("H5Title", "title"));
}}
