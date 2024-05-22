module uim.html.classes.elements.inputs.tel;

@safe:
import uim.html;

class DH5InputTEL: DH5Input {
	mixin(H5This!("Input", null, `["type":"tel"]`, true)); 
}
mixin(H5Short!"InputTEL"); 

version(test_uim_html) { unittest {
		// TODO Add Test
		}}