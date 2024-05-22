module uim.html.classes.elements.link;

@safe:
import uim.html;

class DH5Link : DH5Obj {
  mixin(H5This!("link", null, null, true));

  O styleSheet(this O)(bool mode = true) {
    if (mode) {
      attribues["rel"] = "stylesheet";      
    }
    else {
      if (isStyleSheet)  attributes.remove("rel");
    }
    cast(o)this;
  }
  bool isStyleSheet() { return (attributes.get("rel", null) == "stylesheet"); }

  O icon(this O)(bool mode = true) {
    if (mode) {
      attribues["rel"] = "icon";      
    }
    else {
      if (isIcon)  attributes.remove("rel");
    }
    cast(o)this;
  }
  bool isIcon() { return (attributes.get("rel", null) == "stylesheet"); }
}
mixin(H5Short!("Link"));

version(test_uim_html) { unittest {
  assert(H5Link == "<link>");
}}
