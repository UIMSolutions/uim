module uim.html.classes.elements.figure;

@safe:
import uim.html;

// Wrapper for the figure tag - represents self-contained content, potentially with an optional caption, which is specified using the <figcaption> element.
class DH5Figure : DH5Obj {
	mixin(H5This!"figure");
}
mixin(H5Short!"Figure");

version(test_uim_html) { unittest {
  testH5Obj(H5Figure, "figure");
}}
