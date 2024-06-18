module uim.html.classes.elements.legend;

import uim.html;
@safe:

// Wrapper for <legend> - represents a caption for the content of its parent <fieldset>.
class DH5Legend : DH5Obj {
	mixin(H5This!"legend");
}
mixin(H5Short!"Legend");

version(test_uim_html) { unittest {
  testH5Obj(H5Legend, "legend");
}}
