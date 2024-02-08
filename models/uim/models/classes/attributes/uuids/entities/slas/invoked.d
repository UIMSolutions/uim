/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.slas.invoked;

import uim.models;

@safe:
class DSLAInvokedIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("SLAInvokedIdAttribute"));

  // Initialization hook method.
  override void initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("slainvokedid")
      .registerPath("slaInvokedId");
  }  
}
mixin(AttributeCalls!("SLAInvokedIdAttribute"));

///
unittest {
  auto attribute = new DSLAInvokedIdAttribute;
  assert(attribute.name == "slainvokedid");
  assert(attribute.registerPath == "slaInvokedId");

  DAttribute generalAttribute = attribute;
  assert(cast(DSLAInvokedIdAttribute)generalAttribute);
  assert(cast(DEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DData value = attribute.createValue();
  assert(cast(DUUIDData)value);
}