module uim.html.classes.elements.inputs.search;

import uim.html;
@safe:

class DH5InputSEARCH : DH5Input {
	mixin(H5This!("Input", null, `["type":"search"]`, true)); 
}
mixin(H5Short!"InputSEARCH"); 

version(test_uim_html) { unittest {
		// TODO Add Test
		}}