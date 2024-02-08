/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.users.modifiedonbehalfby;

import uim.models;

@safe:
class DModifiedOnBehalfByAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("ModifiedOnBehalfByAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("modifiedOnBehalfBy")
      .registerPath("modifiedOnBehalfBy");
  }  
}
mixin(AttributeCalls!("ModifiedOnBehalfByAttribute"));

///
unittest {
  auto attribute = new DModifiedOnBehalfByAttribute;
  assert(attribute.name == "modifiedOnBehalfBy");
  assert(attribute.registerPath == "modifiedOnBehalfBy");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DValue value = attribute.createValue();
  assert(cast(DUUIDValue)value);
}