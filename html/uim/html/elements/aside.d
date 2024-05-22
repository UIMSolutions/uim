module uim.html.elements.aside;

@safe:
import uim.html;

// Wrapper for aside tag - represents a portion of a document whose content is only indirectly related to the document's main content. 
// Asides are frequently presented as sidebars or call-out boxes.
class DH5Aside : DH5Obj {
	mixin(H5This!"aside");
}
mixin(H5Short!"Aside");

version(test_uim_html) { unittest {
  testH5Obj(H5Aside, "aside");
  assert(H5Aside == `<aside></aside>`);
}}
