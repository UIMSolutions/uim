module uim.html.elements.option;

@safe:
import uim.html;

class DH5Option : DH5Obj {
	mixin(H5This!"option");

	mixin(MyAttribute!("disabled", "disabled"));
	mixin(MyAttribute!("selected", "selected"));
	mixin(MyAttribute!("value", "value"));
}
mixin(H5Short!"Option");

enum option_modes : string {
	Default = "",
	Selected = "selected",
	Disabled = "disabled"
}

version(test_uim_html) { unittest {
  testH5Obj(H5Option, "option");
	// mixin(testH5DoubleAttributes!("H5Option", "option", ["disabled", "selected", "value"]));
}}

