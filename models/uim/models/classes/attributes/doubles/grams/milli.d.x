/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.grams.milli;

/* Unit of measure for mass in milligrams

Inheritance
any <- float <- double <- gram <- milligram
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.mass
means.measurement.units.si.gram
has.measurement.fundamentalComponent.kilogram
means.measurement.prefix.milli */

import uim.models;

@safe:
class DKilogramAttribute : DGramAttribute {
  mixin(AttributeThis!("KilogramAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("kilogram");
    registerPath("kilogram");

    return true;
  }
}

mixin(AttributeCalls!("KilogramAttribute"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
