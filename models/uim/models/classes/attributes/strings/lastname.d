/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.lastname;

import uim.models;
@safe:

// means.identity.person.lastName
class DLastNameAttribute : DStringAttribute {
  mixin(AttributeThis!("LastNameAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("lastname")
      .registerPath("lastname");
  }
}
mixin(AttributeCalls!("LastNameAttribute"));

///
unittest {
  auto attribute = new DLastNameAttribute;
  assert(attribute.name == "lastname");
  assert(attribute.registerPath == "lastname");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DData value = attribute.createValue();
  assert(cast(DStringValue)value);
}