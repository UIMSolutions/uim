module uim.html.classes.elements.select;

import uim.html;
@safe:

class DH5Select : DH5Obj {
	mixin(H5This!"select");

	mixin(TProperty!("string", "selected"));
	mixin(TProperty!("STRINGAA", "options"));
	mixin(TProperty!("bool", "sorted"));

	mixin(MyContent!("option", "H5Option"));

}
mixin(H5Short!"Select");

version(test_uim_html) { unittest {
	testH5Obj(H5Select, "select");
	
	assert(H5Select.option(["value":"aValue"]) == `<select><option value="aValue"></option></select>`);
	assert(H5Select.option(["value":"aValue"], "someContent") == `<select><option value="aValue">someContent</option></select>`);
}}
