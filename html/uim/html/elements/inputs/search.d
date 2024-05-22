module uim.html.elements.inputs.search;

@safe:
import uim.html;

class DH5InputSEARCH : DH5Input {
	mixin(H5This!("Input", null, `["type":"search"]`, true)); 
}
mixin(H5Short!"InputSEARCH"); 

version(test_uim_html) { unittest {
		// TODO Add Test
		}}