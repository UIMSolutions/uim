module uim.html.elements.content;

@safe:
import uim.html;

class DH5Content : DH5Obj {
	mixin(H5This!("content"));
}
mixin(H5Short!"Content");

version(test_uim_html) { unittest {
  testH5Obj(H5Content, "content");
}}
