module uim.html.classes.elements.link;

import uim.html;

@safe:

class DH5Link : DH5Obj {
  mixin(H5This!("link", null, null, true));

  O styleSheet(this O)(bool mode = true) {
    if (mode) {
      attribues.set("rel", "stylesheet");
    } else {
      if (isStyleSheet)
        attributes.removeByKey("rel");
    }
    cast(o) this;
  }

  bool isStyleSheet() {
    return (attributes.get("rel", null) == "stylesheet");
  }

  O icon(this O)(bool mode = true) {
    if (mode) {
      attribues.set("rel", "icon");
    } else {
      if (isIcon)
        attributes.removeByKey("rel");
    }
    cast(o) this;
  }

  bool isIcon() {
    return (attributes.get("rel", null) == "stylesheet");
  }
}

mixin(H5Short!("Link"));

unittest {
  assert(H5Link == "<link>");
}
