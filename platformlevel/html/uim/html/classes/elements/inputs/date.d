module uim.html.classes.elements.inputs.date;

import uim.html;
@safe:

class DH5InputDate : DH5Input {
	mixin(H5This!("Input", null, `["type":"date"]`, true)); 
}
mixin(H5Short!"InputDate");

version(test_uim_html) { unittest {
    assert(H5InputDate == `<input type="date">`);
}}

