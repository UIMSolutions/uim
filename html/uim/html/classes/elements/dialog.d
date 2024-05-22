module uim.html.elements.dialog;

@safe:
import uim.html;

class DH5Dialog : DH5Obj {
	mixin(H5This!"dialog");
}
mixin(H5Short!"Dialog");

version(test_uim_html) { unittest {
  testH5Obj(H5Dialog, "dialog");
}}
