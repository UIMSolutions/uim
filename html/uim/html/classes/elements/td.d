module uim.html.elements.td;

@safe:
import uim.html;

class DH5Td : DH5Obj {
	mixin(H5This!"td");
}
mixin(H5Short!"Td");

version(test_uim_html) { unittest {
  testH5Obj(H5Td, "td");
}}
