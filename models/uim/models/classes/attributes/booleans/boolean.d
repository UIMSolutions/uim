/***********************************************************************************************
*	Copyright: © 2017-2022 UI Manufaktur UG / 2022 Ozan Nuretin Süel (Sicherheitsschmiede)
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: UI Manufaktur Team
************************************************************************************************/
module uim.models.classes.attributes.booleans.boolean;

import uim.models;

@safe:
class DBooleanAttribute : DAttribute {
  mixin(AttributeThis!("BooleanAttribute"));

  /* Inheritance
any <- boolean
Traits
is.dataFormat.boolean */

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    name("boolean");
    dataFormats(["boolean"]);
    registerPath("boolean");

    return true;
  }

  /* override IData createData() {
    return BoolData(this); } */
}

mixin(AttributeCalls!"BooleanAttribute");

version (test_uim_models) {
  unittest {
    testAttribute(new DBooleanAttribute);
    testAttribute(BooleanAttribute);
  }
}
