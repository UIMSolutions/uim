module uim.html.classes.elements.picture;

import uim.html;
@safe:

class DH5Picture : DH5Obj {
	mixin(H5This!"picture");
}
mixin(H5Short!"Picture");

version(test_uim_html) { unittest {
    testH5Obj(H5Picture, "picture");
}}
