/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.watts.watt;

/* Unit of measure for power or radiant flux in watts

Inheritance
any <- float <- double <- watt
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.power
means.measurement.units.si.watt
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second */

import uim.models;

@safe:
class DWattAttribute : DDoubleAttribute {
  mixin(AttributeThis!("WattAttribute"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    name("watt");
      registerPath("watt");

    return true;

  }
}
mixin(AttributeCalls!("WattAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}