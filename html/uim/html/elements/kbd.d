module uim.html.elements.kbd;

@safe:
import uim.html;

class DH5Kbd : DH5Obj {
	mixin(H5This!"kbd");
}
mixin(H5Short!"Kbd");

version(test_uim_html) { unittest {
  testH5Obj(H5Kbd, "kbd");
}}
