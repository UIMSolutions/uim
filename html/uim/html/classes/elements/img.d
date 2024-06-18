module uim.html.classes.elements.img;

import uim.html;
@safe:

class DH5Img : DH5Obj {
	mixin(H5This!("img", null, null, true));
}
mixin(H5Short!("Img"));

version(test_uim_html) { unittest {
    assert(H5Img);
    assert(H5Img == "<img>");
}}

class DH5Image : DH5Obj {
	mixin(H5This!("img", null, null, true));
}
mixin(H5Short!("Image"));

version(test_uim_html) { unittest {
    assert(H5Image == "<img>");
}}
