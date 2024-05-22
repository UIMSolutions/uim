module uim.html.elements.mark;

@safe:
import uim.html;

// Wrapper for <mark> - represents text which is marked or highlighted for reference or notation purposes, due to the marked passage's relevance or importance in the enclosing context.
class DH5Mark : DH5Obj {
	mixin(H5This!"Mark");
}
mixin(H5Short!"Mark");

version(test_uim_html) { unittest {
  testH5Obj(H5Mark, "mark");
}}
