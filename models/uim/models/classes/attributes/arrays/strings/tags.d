/***********************************************************************************************
*	Copyright: © 2017-2022 UI Manufaktur UG / 2022 Ozan Nuretin Süel (Sicherheitsschmiede)
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: UI Manufaktur Team
************************************************************************************************/
module uim.models.classes.attributes.arrays.strings.tags;

import uim.models;

@safe:
class DTagsAttribute : DStringArrayAttribute {
  mixin(AttributeThis!("Tags"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    name("TagsAttribute");
      dataFormats(["string", "array"]);
      registerPath("TagsAttribute");

    return true;
  }

  /* override Json createData() {
    return TagArrayData(this); } */
}
mixin(AttributeCalls!"Tags");

version(test_uim_models) { unittest {
  testAttribute(new DTagsAttribute);
  testAttribute(TagsAttribute);
}}