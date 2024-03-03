/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.radian;

/* Unit of measure for angle in radians

Inheritance
any <- float <- double <- radian
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.angle
means.measurement.units.si.radian
has.measurement.fundamentalComponent */

import uim.models;

@safe:
class DRadianAttribute : DDoubleAttribute {
  mixin(AttributeThis!("RadianAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("radian");
    registerPath("radian");

    return true;
  }
}

mixin(AttributeCalls!("RadianAttribute"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
