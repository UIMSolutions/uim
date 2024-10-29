module uim.html.classes.elements.td;

import uim.html;
@safe:

class DH5Td : DH5Obj {
	mixin(H5This!"td");
}
mixin(H5Short!"Td");

version(test_uim_html) { unittest {
  testH5Obj(H5Td, "td");
}}
