/***********************************************************************************************
*	Copyright: © 2017-2022 UI Manufaktur UG / 2022 Ozan Nuretin Süel (Sicherheitsschmiede)
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: UI Manufaktur Team
************************************************************************************************/
module uim.models.classes.attributes.arrays.strings.string_;

import uim.models;

@safe:
class DStringArrayAttribute : DAttribute {
  mixin(AttributeThis!("StringArrayAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .name("StringArrayAttribute")
      .dataFormats(["string", "array"])
      .registerPath("StringArrayAttribute");

    return true;
  }

  override IData createValue() {
    return StringArrayValue(this); }
}
mixin(AttributeCalls!"StringArrayAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DStringArrayAttribute);
    testAttribute(StringArrayAttribute);
  }
}