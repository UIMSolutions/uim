/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.meters.kilo;

/* Unit of measure for length in 10E3 meters

is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.length
means.measurement.units.si.meter
has.measurement.fundamentalComponent.meter
means.measurement.prefix.kilo */

import uim.models;

@safe:
class DKilometerAttribute : DMeterAttribute {
  mixin(AttributeThis!("Kilometer"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("kilometer");
    registerPath("kilometer");

    return true;
  }
}

mixin(AttributeCalls!("Kilometer"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
