module uim.html.elements.input;

@safe:
import uim.html;

class DH5Input : DH5Obj {
	mixin(H5This!("input", null, null, true));
	version(test_uim_html) { unittest {
		assert(H5Input == "<input>");
	}}

	mixin(MyAttribute!("type"))	;
	version(test_uim_html) { unittest {
		assert(H5Input.type("text") == `<input type="text">`);
	}}

	mixin(MyAttribute!("accept"));
	mixin(MyAttribute!("autoComplete"));
	mixin(MyAttribute!("autofocus"));
	mixin(MyAttribute!("capture"));
	mixin(MyAttribute!("checked"));
	mixin(MyAttribute!("disabled"));
	
	mixin(MyAttribute!("form"));
	mixin(MyAttribute!("formAction"));
	mixin(MyAttribute!("formEnctype"));
	mixin(MyAttribute!("formMethod"));
	mixin(MyAttribute!("formNoValidate"));
	mixin(MyAttribute!("formTarget"));
	
	mixin(MyAttribute!("height"));
	mixin(MyAttribute!("list"));
	mixin(MyAttribute!("maxLength"));
	mixin(MyAttribute!("min"));
	mixin(MyAttribute!("minLength"));
	mixin(MyAttribute!("multiple"));
	mixin(MyAttribute!("pattern"));
	mixin(MyAttribute!("placeHolder"));
	mixin(MyAttribute!("readOnly"));
	mixin(MyAttribute!("required"));
	
	mixin(MyAttribute!("selectionDirection"));
	mixin(MyAttribute!("selectionEnd"));
	mixin(MyAttribute!("selectionStart"));
	mixin(MyAttribute!("size"));
	mixin(MyAttribute!("src"));
	mixin(MyAttribute!("step"));
	mixin(MyAttribute!("value"));
	mixin(MyAttribute!("width"));
}
mixin(H5Short!("Input"));

version(test_uim_html) { unittest {
	/* mixin(testH5SingleAttributes!("H5Input", "input", 
    [	"accept", "autoComplete",
			"autofocus", "capture", "checked", "disabled", "form", "formAction", "formEnctype", "formMethod", "formNoValidate", "formTarget",
			"height", "list", "maxLength", "min", "minLength", "multiple", "pattern", "placeHolder", "readOnly", "required",
			"selectionDirection", "selectionEnd", "selectionStart", "size", "src", "step", "value", "width"])); */
}}
