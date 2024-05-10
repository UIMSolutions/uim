/***********************************************************************************************
*	Copyright: © 2017-2022 UI Manufaktur UG / 2022 Ozan Nuretin Süel (Sicherheitsschmiede)
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: UI Manufaktur Team
************************************************************************************************/
module uim.models.classes.attributes.arrays.strings.string_;

import uim.models;

@safe:
class DStringArrayAttribute : DAttribute {
  mixin(AttributeThis!("StringArray"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("StringArrayAttribute");
    dataFormats(["string", "array"]);
    registerPath("StringArrayAttribute");

    return true;
  }

  /* override Json createData() {
    return StringArrayData(this);
  } */
}

mixin(AttributeCalls!"StringArrayAttribute");

unittest {
  assert(testAttribute(new DImageAttribute));
  assert(testAttribute(ImageAttribute));
}
