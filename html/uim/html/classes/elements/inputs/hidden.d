module uim.html.classes.elements.inputs.hidden;

import uim.html;
@safe:

class DH5InputHidden : DH5Input {
	mixin(H5This!("Input", null, `["type":"hidden"]`, true)); 
}
mixin(H5Short!"InputHidden"); 

version(test_uim_html) { unittest {
		// TODO Add Test
		}}