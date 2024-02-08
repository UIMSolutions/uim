/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.currency;

import uim.models;
@safe:

// A unique identifier for entity instances

class DCurrencyIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("CurrencyIdAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("currencyId")
      .registerPath("currencyId");
  }  
}
mixin(AttributeCalls!("CurrencyIdAttribute"));

///
unittest {
  auto attribute = new DCurrencyIdAttribute;
  assert(attribute.name == "currencyId");
  assert(attribute.registerPath == "currencyId");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DValue value = attribute.createValue();
  assert(cast(DUUIDValue)value);
}