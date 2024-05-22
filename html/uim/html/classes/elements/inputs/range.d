module uim.html.classes.elements.inputs.range;

@safe:
import uim.html;

class DH5InputRANGE : DH5Input {
	mixin(H5This!("Input", null, `["type":"range"]`, true)); 
}
mixin(H5Short!"InputRANGE"); 

version(test_uim_html) { unittest {
		// TODO Add Test
		}}