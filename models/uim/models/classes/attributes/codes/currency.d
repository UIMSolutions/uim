/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
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
  mixin(AttributeThis!("CurrencyCodeAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

    this
      .name("currencyCode")
      .registerPath("currencyCode");
  }
}
mixin(AttributeCalls!("CurrencyCodeAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}