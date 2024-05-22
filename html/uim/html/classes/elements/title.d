module uim.html.elements.title;

@safe:
import uim.html;

class DH5Title : DH5Obj {
	mixin(H5This!("title"));
}
mixin(H5Short!"Title");

version(test_uim_html) { unittest {
  testH5Obj(H5Title, "title");
  // mixin(testH5DoubleClasses!("H5Title", "title"));
}}
