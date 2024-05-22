module uim.html.classes.elements.inputs.button;

@safe:
import uim.html;

class DH5InputButton : DH5Input {
	mixin(H5This!("Input", null, `["type": "button"]`)); 
}
mixin(H5Short!"InputButton");

version(test_uim_html) { unittest {
	assert(H5InputButton);		
}}