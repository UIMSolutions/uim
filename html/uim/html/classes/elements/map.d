module uim.html.classes.elements.map;

import uim.html;
@safe:

class DH5Map : DH5Obj {
	mixin(H5This!("map"));
}
mixin(H5Short!"MapHelper");

version(test_uim_html) { unittest {
    testH5Obj(H5Map, "map");
}}
