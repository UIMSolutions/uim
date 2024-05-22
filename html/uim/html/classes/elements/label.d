module uim.html.elements.label;

@safe:
import uim.html;

class DH5Label : DH5Obj {
	mixin(H5This!"label");

	mixin(MyAttribute!("forId", "for"));
	version(test_uim_html) { unittest {
		assert(H5Label.forId("anID") == `<label for="anID"></label>`);
		assert(H5Label.forId("anID").content("text") == `<label for="anID">text</label>`);
	}}
	
	mixin(MyAttribute!("form"));
	version(test_uim_html) { unittest {
		assert(H5Label.form("aForm") == `<label form="aForm"></label>`);
		assert(H5Label.form("aForm").content("text") == `<label form="aForm">text</label>`);
	}}
}
mixin(H5Short!"Label");

version(test_uim_html) { unittest {
  testH5Obj(H5Label, `label`);
}}
