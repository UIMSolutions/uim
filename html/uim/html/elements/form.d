module uim.html.elements.form;

@safe:
import uim.html;

@safe:
 class DH5Form : DH5Obj {
mixin(H5This!"form");
	string _targetIFrame;

	/* noValidate - If present, it specifies that the form-data (input) should not be validated when submitted. */
	mixin(MyAttribute!("noValidate", "novalidate"));

	/* acceptCharset - Specifies the character encodings that are to be used for the form submission */
	mixin(TypeField!("string", "acceptCharset", "AcceptCharset"));

	/* action - Specifies where to send the form-data when a form is submitted */
	mixin(TypeField!("string", "action", "Action"));

	/* autoComplete - Specifies whether a form should have autocomplete on or off */
	mixin(TypeField!("string", "autoComplete", "Autocomplete"));

	/* encType - specifies how the form-data should be encoded when submitting it to the server */
//	mixin(EnumField!("EncTypes", "encType"));

	/*  */
	void add(Methods value) { _attributes.remove("method"); _attributes["method"] = value; }
	@property string method() { return _attributes["method"]; } 

	/* The target attribute specifies a name or a keyword that indicates where to display the response that is received after submitting the form.*/
	void add(FormTargets value) { _attributes.remove("target"); if (value != FormTargets.None) { _attributes["target"] = value.toString; } }
	@property string target() { return _attributes["target"]; } 

//	@property auto target(string value) { _targetIFrame = value; target(FormTargets.None); return this; }
//	protected FormTargets _target;
//	@property FormTargets target() { return _target; }
//	@property auto target(FormTargets value) { _target = value; return this; }
//	// void put(string key, FormTargets value) { attributes[key] = cast(string)value; }
//	void put(FormTargets value) { target(value); }

	override public string toString() {
//		if (target != FormTargets.None) set("target", target.toString); 
//		else if (_targetIFrame) set("target", _targetIFrame); 
//
//		if (_acceptCharset) set("accept-charset", acceptCharset);
//		if (_action) set("action", _action);
//		if (_autoComplete) set("autocomplete", _autoComplete);

		return super.toString;
	}
}
mixin(H5Short!"Form");

enum FormTargets : string {
	None = "",
	Blank = "_blank", // The response is displayed in a new window or tab
	Self = "_self", //The response is displayed in the same frame (this is default)
	Parent = "_parent", // The response is displayed in the parent frame
	Top = "_top" // The response is displayed in the full body of the window
}
string toString(FormTargets value) { return cast(string)value; }

enum EncTypes : string {
None = "",
	Application = "application/x-www-form-urlencoded", // (Default) All characters are encoded before sent (spaces are converted to "+" symbols, and special characters are converted to ASCII HEX values)
	Multipart = "multipart/form-data", // No characters are encoded. This value is required when you are using forms that have a file upload control
	Text = "text/plain"
}
string toString(EncTypes value) { return cast(string)value; }

enum Methods : string {
	Get = "get",
	Post = "post"
}
string toString(Methods value) { return cast(string)value; }

version(test_uim_html) { unittest {
  testH5Obj(H5Form, "form");
}}
