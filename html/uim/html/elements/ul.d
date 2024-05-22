module uim.html.elements.ul;

@safe:
import uim.html;

class DH5Ul : DH5Obj {
	mixin(H5This!"ul");

	mixin(MyContent!("li", "H5Li"));
	mixin(MyContent!("item", "H5Li"));
	mixin(MyContent!("link", "this.item", "H5Li"));

	O link(this O)(string id, string[] linkClasses, string src, string title) {
		this.item(id, linkClasses, ["src":src], title); return cast(O)this;
	}
}
mixin(H5Short!"Ul");

version(test_uim_html) { unittest {
	testH5Obj(H5Ul, "ul");
	assert(H5Ul.item == "<ul><li></li></ul>");
	assert(H5Ul.item.item == "<ul><li></li><li></li></ul>");
	assert(H5Ul.item(["test"]) == `<ul><li class="test"></li></ul>`);
	assert(H5Ul.li == "<ul><li></li></ul>");
	assert(H5Ul(`<li></li>`) == "<ul><li></li></ul>");
	assert(H5Ul(H5Li) == "<ul><li></li></ul>");
	assert(H5Ul(H5.li) == "<ul><li></li></ul>");
}}
