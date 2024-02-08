/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.slas.sla;

import uim.models;

@safe:
class DSlaIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("SlaIdAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("slaId")
      .registerPath("slaId");
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

  DData value = attribute.createValue();
  assert(cast(DUUIDData)value);
}