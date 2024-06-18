module uim.html.classes.elements.inputs.reset;

import uim.html;
@safe:

class DH5InputRESET : DH5Input {
	mixin(H5This!("Input", null, `["type":"reset"]`, true)); 
}
mixin(H5Short!"InputRESET"); 

version(test_uim_html) { unittest {
		// TODO Add Test
		}}