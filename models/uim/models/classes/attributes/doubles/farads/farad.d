/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.farads.farad;

/* Unit of measure for electric capacitance in farads

Inheritance
any <- float <- double <- farad
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.capacitance
means.measurement.units.si.farad
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second
has.measurement.fundamentalComponent.ampere */

import uim.models;

@safe:
class DFaradAttribute : DDoubleAttribute {
  mixin(AttributeThis!("Farad"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("farad");
    registerPath("farad");

    return true;
  }
}

mixin(AttributeCalls!("Farad"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
