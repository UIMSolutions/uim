/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.county;

import uim.models;

@safe:

// means.location.county
class DCountyAttribute : DStringAttribute {
  mixin(AttributeThis!("County"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("county");
    registerPath("county");

    return true;
  }
}

mixin(AttributeCalls!("County"));

///
unittest {
  auto attribute = new DCountyAttribute;
  assert(attribute.name == "county");
  assert(attribute.registerPath == "county");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DStringData) value);
}