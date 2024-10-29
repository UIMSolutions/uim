module uim.html.classes.elements.inputs.submit;

import uim.html;
@safe:

class DH5InputSUBMIT : DH5Input {
	mixin(H5This!("Input", null, `["type":"submit"]`, true)); 
}
mixin(H5Short!"InputSUBMIT"); 

version(test_uim_html) { unittest {
		// TODO Add Test
		}}