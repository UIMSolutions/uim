/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.decimals.currencies.base;

import uim.models;

@safe:
class DBaseCurrencyAttribute : DCurrencyAttribute {
  mixin(AttributeThis!("BaseCurrencyAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    /* 
Value is expressed in the base currency units for the system

Inheritance
any <- decimal <- currency <- baseCurrency
Traits
is.dataFormat.numeric.shaped
means.measurement.currency
means.measurement.currency
    */
    this
      .name("baseCurrency")
      .registerPath("baseCurrency");
      
    return true;
  }

  mixin(AttributeCalls!"BaseCurrencyAttribute");

  version (test_uim_models) {
    unittest {
      testAttribute(new DBaseCurrencyAttribute);
      testAttribute(BaseCurrencyAttribute);
    }
  }
