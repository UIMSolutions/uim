module uim.html.classes.elements.fieldset;

@safe:
import uim.html;

class DH5Fieldset : DH5Obj {
	mixin(H5This!"fieldset");
}
mixin(H5Short!"Fieldset");

version(test_uim_html) { unittest {
  testH5Obj(H5Fieldset, "fieldset");
}}
