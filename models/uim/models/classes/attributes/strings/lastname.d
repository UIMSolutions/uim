/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.lastname;

import uim.models;

@safe:

// means.identity.person.lastName
class DLastNameAttribute : DStringAttribute {
  mixin(AttributeThis!("LastName"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    registerPath("attributes.lastname");

    return true;
  }
}
mixin(AttributeCalls!("LastName"));

///
unittest {
  auto attribute = new DLastNameAttribute;
  assert(attribute.name == "LastNameAttribute");
  assert(attribute.registerPath == "attributes.lastname");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DStringData) value);
}
