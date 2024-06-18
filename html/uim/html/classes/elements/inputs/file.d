module uim.html.classes.elements.inputs.file;

import uim.html;
@safe:

class DH5InputFile : DH5Input {
	mixin(H5This!("Input", null, `["type":"file"]`, true)); 
}
mixin(H5Short!"InputFile"); 

version(test_uim_html) { unittest {
		// TODO Add Test
		}}