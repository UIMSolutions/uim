module uim.html.classes.elements.math;

import uim.html;
@safe:

class DH5Math : DH5Obj {
	mixin(H5This!"math");
}
mixin(H5Short!"Math");

version(test_uim_html) { unittest {
    testH5Obj(H5Math, "math");
}}
