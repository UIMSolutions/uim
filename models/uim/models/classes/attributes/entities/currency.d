/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.entities.currency;

import uim.models;
@safe:

// A unique identifier for entity instances

/* class DCurrencyAttribute : DEntityAttribute {
  mixin(AttributeThis!("CurrencyAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("currency")
      .registerPath("currency");
  }  
}
mixin(AttributeCalls!("CurrencyAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DCurrencyAttribute);
    testAttribute(CurrencyAttribute);
  }
} */