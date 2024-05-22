module uim.html.classes.elements.output;

@safe:
import uim.html;

class DH5Output : DH5Obj {
	mixin(H5This!"output");
}
mixin(H5Short!"Output");

version(test_uim_html) { unittest {
  testH5Obj(H5Output, "output");
}}
