module uim.html.classes.elements.textarea;

@safe:
import uim.html;

class DH5Textarea : DH5Obj {
	mixin(H5This!"textarea");

	O cols(this O)(uint value) { if (value > 0) this.attributes("cols", to!string(value)); return cast(O)this; }
	O cols(this O)(string value) { if (value) this.attributes("cols", value); return cast(O)this; }
	version(test_uim_html) { unittest {
		assert(H5Textarea.cols(5) == `<textarea cols="5"></textarea>`);
		assert(H5Textarea.cols("5") == `<textarea cols="5"></textarea>`);
	}}

	O rows(this O)(uint value) { if (value > 0) this.attributes("rows", to!string(value)); return cast(O)this; }
	O rows(this O)(string value) { if (value) this.attributes("rows", value); return cast(O)this; }
	version(test_uim_html) { unittest {
			assert(H5Textarea.rows(10) == `<textarea rows="10"></textarea>`);
			assert(H5Textarea.rows("10") == `<textarea rows="10"></textarea>`);
	}}
}
mixin(H5Short!"Textarea");

version(test_uim_html) { unittest {
  testH5Obj(H5Textarea, "textarea");
}}
