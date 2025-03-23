/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.mixins;

import uim.oop;

public {
  import uim.oop.mixins.obj;
  import uim.oop.mixins.properties;
}

public {
  import uim.oop.mixins.cloneable;
  import uim.oop.mixins.configurable;
  import uim.oop.mixins.configuration;
  import uim.oop.mixins.conventions;
  import uim.oop.mixins.cookiecrypt;
  import uim.oop.mixins.data;
  import uim.oop.mixins.element;
  import uim.oop.mixins.fileconfig;
  import uim.oop.mixins.keys;
  import uim.oop.mixins.mergevariables;
  import uim.oop.mixins.registry;
  import uim.oop.mixins.staticconfig;
  import uim.oop.mixins.valuemap;
}

template ThisElement() {
  const char[] ThisElement = `
  this() { super(); }
  this(string aName) { super(aName); }
  `;
}

template ShortCutElement(string shortcut, string original) {
  const char[] ShortCutElement = `
  `~original~` `~shortcut~`() { return new `~original~`(); }
  `~original~` `~shortcut~`(string aName) { return new `~original~`(aName); }
  `;
}

template SProperty(string dataType, string propertyName) {
  const char[] SProperty = "
  protected "~dataType~" _"~propertyName~";
  @property "~dataType~" "~propertyName~"() { return _"~propertyName~"; }
  @property O "~propertyName~"(this O)("~dataType~" newValue) { _"~propertyName~" = newValue; return cast(O)this; }";
}
