/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
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
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

/* is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.frequency
means.measurement.units.si.hertz
has.measurement.fundamentalComponent.second */

    this
      .name("hertz")
      .registerPath("hertz");
  }
}
mixin(AttributeCalls!("HertzAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}