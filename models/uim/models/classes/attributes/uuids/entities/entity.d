/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.entity;

import uim.models;
@safe:

// A unique identifier for entity instances

class DEntityIdAttribute : DUUIDAttribute {
  mixin(AttributeThis!("EntityIdAttribute"));

/*   is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
is.dataFormat.guid
means.identity.entityId */



}
mixin(AttributeCalls!("EntityIdAttribute"));

///
unittest {
  auto attribute = new DEntityIdAttribute;

  DAttribute generalAttribute = attribute;
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DData value = attribute.createValue();
  assert(cast(DUUIDData)value);
}