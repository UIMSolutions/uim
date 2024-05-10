/***********************************************************************************************
*	Copyright: © 2017-2022 UI Manufaktur UG / 2022 Ozan Nuretin Süel (Sicherheitsschmiede)
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: UI Manufaktur Team
************************************************************************************************/
module models.uim.models.classes.attributes.booleans.boolean;

import uim.models;

@safe:
class DBooleanAttribute : DAttribute {
  mixin(AttributeThis!("Boolean"));

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

  // TODO
  /* override */ Json createData() {
    Json result = Json.emptyObject; // TODO super.createData;
    return result; }
}

mixin(AttributeCalls!"Boolean");

  unittest {
    testAttribute(new DBooleanAttribute);
    testAttribute(BooleanAttribute);
}
