/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.string_;

import uim.models;

@safe:
class DStringAttribute : DCharAttribute {
  mixin(AttributeThis!"String");

  mixin(TProperty!("size_t", "maxLength"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("string");
    isString(true);
    registerPath("string");

    return true;
  }

  /* override Json createData() {
    return StringData(this)
      .maxLength(this.maxLength);
  } */
}

mixin(AttributeCalls!"String");

///
unittest {
  auto attribute = new DStringAttribute;
  assert(attribute.name == "string");
  assert(attribute.registerPath == "string");

  DAttribute generalAttribute = attribute;
  assert(!cast(DIntegerAttribute) generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DStringData) value);
}
