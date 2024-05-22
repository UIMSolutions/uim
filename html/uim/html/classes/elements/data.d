module uim.html.classes.elements.data;

@safe:
import uim.html;

class DH5Data : DH5Obj {
	mixin(H5This!"data");
}
mixin(H5Short!"Data");

version(test_uim_html) { unittest {
  testH5Obj(H5Data, "data");
}}
