module uim.html.classes.elements.header;

import uim.html;
@safe:

class DH5Header : DH5Obj {
	mixin(H5This!("header"));
}
mixin(H5Short!"Header");

version(test_uim_html) { unittest {
  testH5Obj(H5Header, "header");
}}
