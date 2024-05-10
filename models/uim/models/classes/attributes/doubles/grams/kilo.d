/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.grams.kilo;

/* Unit of measure for mass in kilogram

Inheritance
any <- float <- double <- kilogram
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.mass
means.measurement.units.si.kilogram
has.measurement.fundamentalComponent.kilogram */

import uim.models;

@safe:
class DKilogramAttribute : DGramAttribute {
  mixin(AttributeThis!("Kilogram"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    name("kilogram"); 
    registerPath("kilogram");

    return true;
  }
}
mixin(AttributeCalls!("Kilogram"));

version(test_uim_models) { unittest {
    // TODO
  }
}