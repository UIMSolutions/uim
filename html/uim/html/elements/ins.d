module uim.html.elements.ins;

@safe:
import uim.html;

// Wrapper for <ins> - represents a range of text that has been added to a document.
class DH5Ins : DH5Obj {
	mixin(H5This!"ins");
}
mixin(H5Short!"Ins");

version(test_uim_html) { unittest {
    testH5Obj(H5Ins, "ins");
}}
