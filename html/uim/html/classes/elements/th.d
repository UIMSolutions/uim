﻿module uim.html.classes.elements.th;

import uim.html;
@safe:

class DH5Th : DH5Obj {
	mixin(H5This!"th");
}
mixin(H5Calls!("H5Th", "DH5Th"));

version(test_uim_html) { unittest {
  testH5Obj(H5Th, "th");
}}
