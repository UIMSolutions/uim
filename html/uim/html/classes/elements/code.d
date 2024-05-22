module uim.html.classes.elements.code;

@safe:
import uim.html;

// Wrapper for code tag - displays its contents styled in a fashion intended to indicate that the text is a short fragment of computer code.
class DH5Code : DH5Obj {
	mixin(H5This!"code");
}
mixin(H5Short!"Code");

version(test_uim_html) { unittest {
  testH5Obj(H5Code, "code");
}}
