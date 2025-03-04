module uim.html.classes.elements.inputs.week;

import uim.html;
@safe:

class DH5InputWEEK : DH5Input {
	mixin(H5This!("Input", null, `["type":"week"]`, true)); 
}
mixin(H5Short!"InputWEEK"); 

version(test_uim_html) { unittest {
		// TODO Add Test
		}}