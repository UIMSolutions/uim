/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.link;

import uim.models;

@safe:
class DLinkAttribute : DStringAttribute {
  mixin(AttributeThis!("Link"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("link");
    registerPath("link");

    return true;
  }
}

mixin(AttributeCalls!("Link"));

///
unittest {
  auto attribute = new DLinkAttribute;
  assert(attribute.name == "link");
  assert(attribute.registerPath == "link");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DStringData) value);
}