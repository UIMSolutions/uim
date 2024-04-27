/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.farads.pico;

/* Unit of capacitance, equivalent to 10E-12 farads

Inheritance
any <- float <- double <- farad <- picofarad
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.capacitance
means.measurement.units.si.farad
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second
has.measurement.fundamentalComponent.ampere
means.measurement.prefix.pico */

import uim.models;

@safe:
class DPicoFaradAttribute : DFaradAttribute {
  mixin(AttributeThis!("PicoFaradAttribute"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("picoFarad");
    registerPath("picoFarad");

    return true;
  }
}

mixin(AttributeCalls!("PicoFaradAttribute"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
