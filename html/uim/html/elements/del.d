module uim.html.elements.del;

@safe:
import uim.html;

class DH5Del : DH5Obj {
	mixin(H5This!"del");
}
mixin(H5Short!"Del");

version(test_uim_html) { unittest {
  testH5Obj(H5Del, "del");
}}
