module uim.html.elements.inputs.month;

@safe:
import uim.html;

class DH5InputMONTH : DH5Input {
	mixin(H5This!("Input", null, `["type":"month"]`, true)); 
}
mixin(H5Short!"InputMONTH"); 

version(test_uim_html) { unittest {
		// TODO Add Test
		}}