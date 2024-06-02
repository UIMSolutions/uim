/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.codes.currency;

import uim.models;

@safe:

// is.dataFormat.character
// is.dataFormat.big
// is.dataFormat.array
// means.measurement.currencyCode
// Value is a ISO 4217 currency code
class DCurrencyCodeAttribute : DStringStringAttribute {
  mixin(AttributeThis!("CurrencyCode"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("currencyCode");
    registerPath("currencyCode");

    return true;

  }
}

mixin(AttributeCalls!("CurrencyCode"));

unittest {
  assert(testAttribute(new DCurrencyCodeAttribute));
  assert(testAttribute(CurrencyCodeAttribute));
}