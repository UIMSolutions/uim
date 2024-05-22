module uim.html.classes.elements.inputs.datetimelocal;

@safe:
import uim.html;

class DH5InputDATETIMELOCAL : DH5Input {
	mixin(H5This!("Input", null, `["type":"datetime-local"]`)); 
}
mixin(H5Short!"InputDATETIMELOCAL");

