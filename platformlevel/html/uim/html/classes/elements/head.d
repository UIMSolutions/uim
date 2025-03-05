module uim.html.classes.elements.head;

import uim.html;
@safe:

class DH5Head : DH5Obj {
protected:
	string _title;
public:
	mixin(H5This!("head"));

	 DH5Head Meta(string[string] values) { this.add(H5Meta(values)); return this; }
	DH5Head Base(string[string] values) { this.add(H5Base(values)); return this; }
	 DH5Head Link(string[string] values) { this.add(H5Link(values)); return this; }
	 DH5Head Link(string href, string media = "") { 
		if (media) return Link(["rel":"stylesheet", "href": href, "type":"text/css", "media":media]);
		else return Link(["rel":"stylesheet", "href": href, "type":"text/css"]);
	}
	 DH5Head Title(string content = null) { this.add(H5Title(content)); return this; }

	 O scripts(this O)(string[] links) { foreach(l; links) add(H5Script(["src":l])); return cast(O)this; }
	 O script(this O, T...)(T values) { add(H5Script(values)); return cast(O)this; }
}
mixin(H5Short!"Head");

version(test_uim_html) { unittest {	
	testH5Obj(H5Head, "head");
}}
