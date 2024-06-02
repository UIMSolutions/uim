/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.meters.milli;

import uim.models;

@safe:

/* Unit of measure for length in 10E-3 meters

Inheritance
any <- float <- double <- meter <- millimeter
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.length
means.measurement.units.si.meter
has.measurement.fundamentalComponent.meter
means.measurement.prefix.milli */

import uim.models;

@safe:
class DMillimeterAttribute : DMeterAttribute {
  mixin(AttributeThis!("Millimeter"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("millimeter");
    registerPath("millimeter");

    return true;
  }
}

mixin(AttributeCalls!("Millimeter"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
