module uim.html.classes.elements.inputs.text;

import uim.html;
@safe:

class DH5InputText : DH5Input {
	mixin(H5This!("Input", null, `["type":"text"]`, true)); 
}
mixin(H5Short!"InputText"); 

version(test_uim_html) { unittest {
		// TODO Add Test
		}}