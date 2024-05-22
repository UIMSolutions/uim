module uim.html.elements.track;

@safe:
import uim.html;

class DH5Track : DH5Obj {
	mixin(H5This!"track");
	
	mixin(MyAttribute!("isDefault", "default"));
  mixin(MyAttribute!"label");
  mixin(MyAttribute!"src");
  mixin(MyAttribute!"srclang");
}
mixin(H5Short!"Track");

version(test_uim_html) { unittest {
  testH5Obj(H5Track, `track`);

	// mixin(testH5DoubleAttributes!("H5Track", "track", ["label", "src", "srclang"]));
}}
