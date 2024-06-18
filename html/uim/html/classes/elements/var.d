module uim.html.classes.elements.var;

import uim.html;
@safe:

class DH5Var : DH5Obj {
	mixin(H5This!"var");
}
mixin(H5Short!"Var");

version(test_uim_html) { unittest {
    assert(H5Var,"<var></var>");
}}
