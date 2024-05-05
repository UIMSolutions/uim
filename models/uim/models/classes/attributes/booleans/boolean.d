/***********************************************************************************************
*	Copyright: © 2017-2022 UI Manufaktur UG / 2022 Ozan Nuretin Süel (Sicherheitsschmiede)
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: UI Manufaktur Team
************************************************************************************************/
module models.uim.models.classes.attributes.booleans.boolean;

import uim.models;

@safe:
class DBooleanAttribute : DAttribute {
  mixin(AttributeThis!("BooleanAttribute"));

  /* Inheritance
any <- boolean
Traits
is.dataFormat.boolean */

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("boolean");
    dataFormats(["boolean"]);
    registerPath("boolean");

    return true;
  }

  override Json createData() {
    Json result = super.createData;
    return result; }
}

mixin(AttributeCalls!"BooleanAttribute");

version (test_uim_models) {
  unittest {
    testAttribute(new DBooleanAttribute);
    testAttribute(BooleanAttribute);
  }
}
