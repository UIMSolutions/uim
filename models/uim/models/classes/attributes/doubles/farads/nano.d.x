/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.farads.nano;

/* Unit of capacitance, equivalent to 10E-9 farads

Inheritance
any <- float <- double <- farad <- nanofarad
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.capacitance
means.measurement.units.si.farad
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second
has.measurement.fundamentalComponent.ampere
means.measurement.prefix.nano */

import uim.models;

@safe:
class DNanoFaradAttribute : DFaradAttribute {
  mixin(AttributeThis!("NanoFaradAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("nanoFarad");
    registerPath("nanoFarad");

    return true;
  }
}

mixin(AttributeCalls!("NanoFaradAttribute"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
