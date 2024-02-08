/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.decimals.currencies.currency;

import uim.models;

@safe:
class DCurrencyAttribute : DDecimalAttribute {
  mixin(AttributeThis!("CurrencyAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

    /* is.dataFormat.numeric.shaped
    means.measurement.currency */
  }
}
mixin(AttributeCalls!"CurrencyAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DCurrencyAttribute);
    testAttribute(CurrencyAttribute);
  }
}