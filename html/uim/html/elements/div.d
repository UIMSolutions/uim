module uim.html.elements.div;

@safe:
import uim.html;

class DH5Div : DH5Obj {
	mixin(H5This!"div");
}
mixin(H5Short!"Div");

version(test_uim_html) { unittest {
  assert(H5Div);
  assert(H5Div == `<div></div>`);

  testH5Obj(H5Div, "div");
  
	// mixin(testH5Double!("H5Div", "div", true));	
	// mixin(testH5DoubleClasses!("H5Div", "div", true));	
}}
