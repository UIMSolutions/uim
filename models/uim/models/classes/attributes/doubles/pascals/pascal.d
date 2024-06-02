/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.pascals.pascal;

/* pascal
Description

Unit of measure for pressure or stress in pascals

Inheritance
any <- float <- double <- pascal
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.pressure
means.measurement.units.si.pascal
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second */

import uim.models;

@safe:
class DPascalAttribute : DDoubleAttribute {
  mixin(AttributeThis!("Pascal"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("pascal");
    registerPath("pascal");

    return true;
  }
}

mixin(AttributeCalls!("Pascal"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
