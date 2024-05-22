module uim.html.elements.source;

@safe:
import uim.html;

class DH5Source : DH5Obj {
	mixin(H5This!"source");
	
	mixin(MyAttribute!"sizes");
  mixin(MyAttribute!"src");
  mixin(MyAttribute!"srcset");
  mixin(MyAttribute!"type");
  mixin(MyAttribute!"media"); 
}
mixin(H5Short!"Source");

version(test_uim_html) { unittest {
	testH5Obj(H5Source, "source");
	mixin(testH5DoubleAttributes!("H5Source", "source", [
    "sizes", "src", "srcset", "type", "media"]));
}}
