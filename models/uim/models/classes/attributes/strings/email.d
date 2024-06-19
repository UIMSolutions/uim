/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.email;

import uim.models;

@safe:

// means.identity.person.email
class DEmailAttribute : DStringAttribute {
  mixin(AttributeThis!("Email"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    registerPath("attributes.email");

    return true;
  }
}

mixin(AttributeCalls!("Email"));

///
unittest {
  auto attribute = new DEmailAttribute;
  assert(attribute.name == "EmailAttribute");
  assert(attribute.registerPath == "attributes.email");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DStringData) value);
}
