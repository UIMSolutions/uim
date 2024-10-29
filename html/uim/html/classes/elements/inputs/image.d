module uim.html.classes.elements.inputs.image;

import uim.html;
@safe:

class DH5InputIMAGE : DH5Input {
	mixin(H5This!("Input", null, `["type":"image"]`, true)); 
}
mixin(H5Short!"InputIMAGE"); 

version(test_uim_html) { unittest {
		// TODO Add Test
		}}