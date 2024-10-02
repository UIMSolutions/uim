/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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

unittest {
  assert(testAttribute(new DTagsAttribute));
  assert(testAttribute(TagsAttribute));
}
