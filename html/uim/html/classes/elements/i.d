module uim.html.classes.elements.i;

@safe:
import uim.html;

// Wrapper for <i> tag - represents a range of text that is set off from the normal text for some reason, such as idiomatic text, technical terms, taxonomical designations, among others.
class DH5I : DH5Obj {
	mixin(H5This!"I");
}
mixin(H5Short!"I");

version(test_uim_html) { unittest {
  testH5Obj(H5I, "i");
}}     
