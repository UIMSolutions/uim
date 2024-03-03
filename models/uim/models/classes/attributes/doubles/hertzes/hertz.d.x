/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.hertzes.hertz;

/* Unit of measure for frequency in hertz

Inheritance
any <- float <- double <- hertz
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.frequency
means.measurement.units.si.hertz
has.measurement.fundamentalComponent.second */

// hertz
// Unit of measure for luminous intensity in hertzs

import uim.models;

@safe:
class DHertzAttribute : DDoubleAttribute {
  mixin(AttributeThis!("HertzAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    /* is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.frequency
means.measurement.units.si.hertz
has.measurement.fundamentalComponent.second */

    name("hertz");
    registerPath("hertz");

    return true;
  }
}

mixin(AttributeCalls!("HertzAttribute"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
