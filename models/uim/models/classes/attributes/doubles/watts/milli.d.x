/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.watts.milli;

/* Unit of power, equivalent to 10E-3 watts

Inheritance
any <- float <- double <- watt <- milliwatt
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.power
means.measurement.units.si.watt
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second
means.measurement.prefix.milli */

import uim.models;

@safe:
class DMilliWattAttribute : DWattAttribute {
  mixin(AttributeThis!("MilliWattAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    name("milliwatt");
    registerPath("milliwatt");

    return true;
  }
}

mixin(AttributeCalls!("MilliWattAttribute"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
