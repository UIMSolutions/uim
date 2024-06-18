module uim.html.classes.elements.bdo;

import uim.html;
@safe:

// Wrapper for the bdo tag - overrides the current directionality of text, so that the text within is rendered in a different direction.
class DH5Bdo : DH5Obj {
	mixin(H5This!"bdo");
}
mixin(H5Short!"Bdo");

version(test_uim_html) { unittest {
  testH5Obj(H5Bdo, "bdo");
}}
