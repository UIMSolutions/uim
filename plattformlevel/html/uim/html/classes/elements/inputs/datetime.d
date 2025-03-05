module uim.html.classes.elements.inputs.datetime;

import uim.html;
@safe:

class DH5InputDATETIME : DH5Input {
	mixin(H5This!("Input", null, `["type":"datetime"]`, false)); 
}

version(test_uim_html) { unittest {
		// TODO Add Test
		}}