/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.list;

import uim.models;

@safe:

// A CSV contained within one string value
// means.content.text.CSV
class DListAttribute : DStringAttribute {
  mixin(AttributeThis!("List"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    registerPath("attributes.list");

    return true;
  }
}

mixin(AttributeCalls!("List"));

///
unittest {
  auto attribute = new DListAttribute;
  assert(attribute.name == "list");
  assert(attribute.registerPath == "attributes.list");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DStringData) value);
}
