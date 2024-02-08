/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.slas.invoked;

import uim.models;

@safe:
class DSLAInvokedIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("SLAInvokedIdAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    name("slainvokedid");
    registerPath("slaInvokedId");

    return true;
  }
}

mixin(AttributeCalls!("SLAInvokedIdAttribute"));

///
unittest {
  auto attribute = new DSLAInvokedIdAttribute;
  assert(attribute.name == "slainvokedid");
  assert(attribute.registerPath == "slaInvokedId");

  DAttribute generalAttribute = attribute;
  assert(cast(DSLAInvokedIdAttribute) generalAttribute);
  assert(cast(DEntityIdAttribute) generalAttribute);
  assert(cast(DUUIDAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  DData value = attribute.createValue();
  assert(cast(DUUIDData) value);
}
