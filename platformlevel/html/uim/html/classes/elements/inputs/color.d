module uim.html.classes.elements.inputs.color;

import uim.html;
@safe:

class DH5InputCOLOR : DH5Input {
	mixin(H5This!""); 

	override string toString() {
		this["TYPE"] = "color";
		return super.toString;
	}
}

version(test_uim_html) { unittest {
		// TODO Add Test
		}}