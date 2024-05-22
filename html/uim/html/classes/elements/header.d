module uim.html.classes.elements.header;

@safe:
import uim.html;

class DH5Header : DH5Obj {
	mixin(H5This!("header"));
}
mixin(H5Short!"Header");

version(test_uim_html) { unittest {
  testH5Obj(H5Header, "header");
}}
