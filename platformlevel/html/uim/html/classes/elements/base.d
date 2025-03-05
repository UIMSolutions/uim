module uim.html.classes.elements.base;

import uim.html;
@safe:

// Wrapper for the base tag - specifies the base URL and/or target for all relative URLs in a document. 
class DH5Base : DH5Obj {
	mixin(H5This!("base"));

  // Attribute href - Specifies the base URL for all relative URLs in the page
  mixin(MyAttribute!("href"));   

  // Attribute target - A keyword or author-defined name of the default browsing context to show the results of navigation
  mixin(MyAttribute!("target")); // _blank, _parent, _self o. _top - Specifies the default target for all hyperlinks and forms in the page
}
mixin(H5Short!"Base");

version(test_uim_html) { unittest {
  testH5Obj(H5Base, "base");
	mixin(TestH5DoubleAttributes!("H5Base", "base", [
    "autoplay", "buffered", "controls", "crossorigin", "disableremoteplayback", "loop", "muted", "preload", "src"]));
}}
