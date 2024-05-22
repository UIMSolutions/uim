module uim.html.classes.elements.sub;

@safe:
import uim.html;

class DH5Sub : DH5Obj {
	mixin(H5This!"sub");
}
mixin(H5Short!"Sub");

version(test_uim_html) { unittest {
  testH5Obj(H5Sub, "sub");
}}
