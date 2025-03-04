module uim.html.classes.elements.col;

import uim.html;
@safe:

// WRapper for col tag - defines a column within a table and is used for defining common semantics on all common cells.
class DH5Col : DH5Obj {
	mixin(H5This!"col");

  mixin(MyAttribute!("span"));
  version(test_uim_html) { unittest {
    assert(H5Col.span("1") == `<col span="1"></col>`);
  }}
}
mixin(H5Short!"Col");

version(test_uim_html) { unittest {
  testH5Obj(H5Col, "col");
}}
