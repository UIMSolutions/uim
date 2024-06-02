/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.kelvin;

/* Unit of measure for thermodynamic temperature in degrees kelvin

Inheritance
any <- float <- double <- kelvin
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.temperature
means.measurement.units.si.kelvin
has.measurement.fundamentalComponent.kelvin */

import uim.models;

@safe:
class DKelvinAttribute : DDoubleAttribute {
  mixin(AttributeThis!("Kelvin"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("kelvin");
    registerPath("kelvin");

    return true;
  }
}

mixin(AttributeCalls!("Kelvin"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
