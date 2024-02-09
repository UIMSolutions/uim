/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.slas.sla;

import uim.models;

@safe:
class DSlaIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("SlaIdAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    name("slaId");
    registerPath("slaId");

   return true;

  }  
}
mixin(AttributeCalls!("SlaIdAttribute"));

///
unittest {
  auto attribute = new DSlaIdAttribute;
  assert(attribute.name == "slaId");
  assert(attribute.registerPath == "slaId");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  // IData value = attribute.createValue();
  // assert(cast(DUUIDData)value);
}