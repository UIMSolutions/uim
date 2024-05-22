module uim.html.classes.elements.inputs.password;

@safe:
import uim.html;

class DH5InputPASSWORD : DH5Input {
	mixin(H5This!("Input", null, `["type":"password"]`, true)); 
}
mixin(H5Short!"InputPASSWORD"); 

version(test_uim_html) { unittest {
		// TODO Add Test
		}}