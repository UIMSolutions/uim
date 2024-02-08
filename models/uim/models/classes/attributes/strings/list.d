/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.list;

import uim.models;
@safe:

// A CSV contained within one string value
// means.content.text.CSV
class DListAttribute : DStringAttribute {
  mixin(AttributeThis!("ListAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("list")
      .registerPath("list");
  }
}
mixin(AttributeCalls!("ListAttribute"));

///
unittest {
  auto attribute = new DListAttribute;
  assert(attribute.name == "list");
  assert(attribute.registerPath == "list");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DValue value = attribute.createValue();
  assert(cast(DStringValue)value);
}