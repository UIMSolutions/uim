module uim.html.elements.details;

@safe:
import uim.html;

class DH5Details: DH5Obj {
	mixin(H5This!"details");
}
mixin(H5Short!"Details");

version(test_uim_html) { unittest {
  testH5Obj(H5Details, "details");
}}
