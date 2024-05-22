module uim.html.classes.elements.rt;

@safe:
import uim.html;

class DH5Rt : DH5Obj {
	mixin(H5This!"rt");
}
mixin(H5Short!"Rt");

version(test_uim_html) { unittest {
  testH5Obj(H5Rt, "rt");
}}
