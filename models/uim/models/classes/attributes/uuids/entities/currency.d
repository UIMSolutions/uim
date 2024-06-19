/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
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

      registerPath("attributes.currencyid");

      return true;
  }  
}
mixin(AttributeCalls!("CurrencyId"));

///
unittest {
  auto attribute = new DCurrencyIdAttribute;
  assert(attribute.name == "CurrencyIdAttribute");
  assert(attribute.registerPath == "attributes.currencyid");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DUUIDData)value);
}