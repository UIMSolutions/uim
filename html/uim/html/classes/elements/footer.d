module uim.html.elements.footer;

@safe:
import uim.html;

class DH5Footer : DH5Obj {
	mixin(H5This!("Footer"));
}
mixin(H5Short!"Footer");

version(test_uim_html) { unittest {	
	testH5Obj(H5Footer, "footer");
}}
