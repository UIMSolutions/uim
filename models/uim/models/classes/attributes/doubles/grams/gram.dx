/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.grams.gram;

/* Unit of measure for mass in grams

Inheritance
any <- float <- double <- gram
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.mass
means.measurement.units.si.gram
has.measurement.fundamentalComponent.gram */

import uim.models;

@safe:
class DGramAttribute : DDoubleAttribute {
  mixin(AttributeThis!("Gram"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("gram");
    registerPath("gram");

    return true;
  }
}

mixin(AttributeCalls!("Gram"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
