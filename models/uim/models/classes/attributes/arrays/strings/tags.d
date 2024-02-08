/***********************************************************************************************
*	Copyright: © 2017-2022 UI Manufaktur UG / 2022 Ozan Nuretin Süel (Sicherheitsschmiede)
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: UI Manufaktur Team
************************************************************************************************/
module uim.models.classes.attributes.arrays.strings.tags;

import uim.models;

@safe:
class DTagsAttribute : DStringArrayAttribute {
  mixin(AttributeThis!("TagsAttribute"));

  // Initialization hook method.
  override void initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("TagsAttribute")
      .dataFormats(["string", "array"])
      .registerPath("TagsAttribute");
  }

  override DData createValue() {
    return TagArrayValue(this); }
}
mixin(AttributeCalls!"TagsAttribute");

version(test_uim_models) { unittest {
  testAttribute(new DTagsAttribute);
  testAttribute(TagsAttribute);
}}