/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.email;

import uim.models;
@safe:

// means.identity.person.email
class DEmailAttribute : DStringAttribute {
  mixin(AttributeThis!("EmailAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

    this
      .name("email")
      .registerPath("email");
  }
}
mixin(AttributeCalls!("EmailAttribute"));

///
unittest {
  auto attribute = new DEmailAttribute;
  assert(attribute.name == "email");
  assert(attribute.registerPath == "email");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DData value = attribute.createValue();
  assert(cast(DStringData)value);
}