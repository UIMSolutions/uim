module uim.html.classes.elements.inputs.reset;

@safe:
import uim.html;

class DH5InputRESET : DH5Input {
	mixin(H5This!("Input", null, `["type":"reset"]`, true)); 
}
mixin(H5Short!"InputRESET"); 

version(test_uim_html) { unittest {
		// TODO Add Test
		}}