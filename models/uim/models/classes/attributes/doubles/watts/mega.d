/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.watts.mega;

/* megawatt
Description

Unit of power, equivalent to 10E6 watts

Inheritance
any <- float <- double <- watt <- megawatt
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.power
means.measurement.units.si.watt
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second
means.measurement.prefix.mega */

import uim.models;

@safe:
class DMegaWattAttribute : DWattAttribute {
  mixin(AttributeThis!("MegaWattAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("megawatt")
      .registerPath("megawatt");
  }
}
mixin(AttributeCalls!("MegaWattAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}