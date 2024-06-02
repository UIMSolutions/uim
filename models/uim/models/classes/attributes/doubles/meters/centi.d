/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.meters.centi;

// Unit of measure for length in 10E-2 meters
/* any <- float <- double <- meter <- centimeter
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.length
means.measurement.units.si.meter
has.measurement.fundamentalComponent.meter
means.measurement.prefix.centi */

import uim.models;

@safe:
class DCentimeterAttribute : DMeterAttribute {
  mixin(AttributeThis!("Centimeter"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    name("centimeter");
    registerPath("centimeter");

    return true;
  }
}
mixin(AttributeCalls!("Centimeter"));

version(test_uim_models) { unittest {
    // TODO
  }
}