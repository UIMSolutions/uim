/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.currency;

import uim.models;
@safe:

// A unique identifier for entity instances

class DCurrencyIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("CurrencyId"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    name("currencyId");
      registerPath("currencyId");

      return true;
  }  
}
mixin(AttributeCalls!("CurrencyId"));

///
unittest {
  auto attribute = new DCurrencyIdAttribute;
  assert(attribute.name == "currencyId");
  assert(attribute.registerPath == "currencyId");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DUUIDData)value);
}