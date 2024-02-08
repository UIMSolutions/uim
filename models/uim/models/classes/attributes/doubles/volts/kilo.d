/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.volts.kilo;

/* Unit of power, equivalent to 10E3 volts

Inheritance
any <- float <- double <- volt <- kilovolt
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.electromotiveForce
means.measurement.units.si.volt
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second
has.measurement.fundamentalComponent.ampere
means.measurement.prefix.kilo */

import uim.models;

@safe:
class DKiloVoltAttribute : DVoltAttribute {
  mixin(AttributeThis!("KiloVoltAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("kilovolt")
      .registerPath("kilovolt");
  }
}
mixin(AttributeCalls!("KiloVoltAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}