﻿module uim.html.classes.elements.object;

import uim.html;
@safe:

class DH5Object : DH5Obj {
	mixin(H5This!"object");
}
mixin(H5Short!"Object");

version(test_uim_html) { unittest {
    assert(H5Object == "<object></object>");
}}
