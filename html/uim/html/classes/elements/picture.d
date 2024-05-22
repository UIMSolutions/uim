module uim.html.classes.elements.picture;

@safe:
import uim.html;

class DH5Picture : DH5Obj {
	mixin(H5This!"picture");
}
mixin(H5Short!"Picture");

version(test_uim_html) { unittest {
    testH5Obj(H5Picture, "picture");
}}
