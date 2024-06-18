module uim.html.classes.elements.inputs.radio;

import uim.html;
@safe:

class DH5Radio : DH5Input {
	mixin(H5This!("Input", null, `["type":"radio"]`, true)); 
}
mixin(H5Short!"Radio"); 

version(test_uim_html) { unittest {
		// TODO Add Test
		}}