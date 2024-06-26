﻿module uim.html.classes.elements.abbr;

import uim.html;
@safe:

// Wrapper for <abbr> - represents an abbreviation or acronym.
class DH5Abbr : DH5Obj {
	mixin(H5This!"abbr");
}
mixin(H5Short!"Abbr");

version(test_uim_html) { unittest {
	testH5Obj(H5Abbr, "abbr");
  
  assert(H5Abbr == `<abbr><abbr>`);
}}
