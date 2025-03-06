module uim.html.classes.elements.b;

@safe:
import uim.html;

// Wrapper for the <b> tag - specifies bold text.
class DH5B : DH5Obj {
	mixin(H5This!"b");
}	
mixin(H5Short!"B");

///
/* unittest {
	auto element = new DH5B;
	assert(element == "<b></b>");
}

version(test_uim_html) { unittest {
  testH5Obj(H5B, "b");
}}

 */