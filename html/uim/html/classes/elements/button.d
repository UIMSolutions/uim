module uim.html.classes.elements.button;

@safe:
import uim.html;

class DH5Button : DH5Obj {
	mixin(H5This!"button");

	/* type */
//	ButtonTypes _type = ButtonTypes.Button;
//	@property ButtonTypes type() { return _type; }
//	@property O type(this O)(ButtonTypes value) { 
//		_type = value; 
//		attributes["type"] = to!string(value);
//		return cast(O)this; }
}
mixin(H5Short!"Button");

enum ButtonTypes : string {
	Button = "button",
	Submit = "submit",
	Reset = "reset"
}

version(test_uim_html) { unittest {
	assert(H5Button,"<button></button>");

	//	assert(H5Button.type(ButtonTypes.Button).attributes.getString("type") == "button");
	//	assert(H5Button.type(ButtonTypes.Reset).attributes.getString("type") == "submit");
	//	assert(H5Button.type(ButtonTypes.Submit).attributes.getString("type") == "reset");
}}
