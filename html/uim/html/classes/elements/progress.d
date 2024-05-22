module uim.html.classes.elements.progress;

@safe:
import uim.html;

class DH5Progress : DH5Obj {
	mixin(H5This!"progress");
}
mixin(H5Short!"Progress");

version(test_uim_html) { unittest {
    assert(H5Progress == "<progress></progress>");
}}
