/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.newton;

/* Unit of measure for force or weight in newtons

Inheritance
any <- float <- double <- newton
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.force
means.measurement.units.si.newton
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second */

import uim.models;

@safe:
class DNewtonAttribute : DDoubleAttribute {
  mixin(AttributeThis!("Newton"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("newton");
    registerPath("newton");

    return true;
  }
}

mixin(AttributeCalls!("Newton"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
