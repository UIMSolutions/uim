module uim.html.classes.elements.inputs.email;

import uim.html;
@safe:

class DH5InputEmail : DH5Input {
	mixin(H5This!("Input", null, `["type":"email"]`, true)); 
}
mixin(H5Short!"InputEmail");

version(test_uim_html) { unittest {
    assert(H5InputEmail == `<input type="email">`);
}}