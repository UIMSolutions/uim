/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.volts.volt;

/* Unit of measure for voltage, EMF, electrical potantial difference in volts

Inheritance
any <- float <- double <- volt
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.electromotiveForce
means.measurement.units.si.volt
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.volt
has.measurement.fundamentalComponent.ampere */

import uim.models;

@safe:
class DVoltAttribute : DDoubleAttribute {
  mixin(AttributeThis!("VoltAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("volt")
      .registerPath("volt");
  }
}
mixin(AttributeCalls!("VoltAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}