/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.farads.micro;

/* Unit of capacitance, equivalent to 10E-6 microfarads

Inheritance
any <- float <- double <- microfarad <- micromicrofarad
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.capacitance
means.measurement.units.si.microfarad
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second
has.measurement.fundamentalComponent.microfarad
means.measurement.prefix.micro */

import uim.models;

@safe:
class DMicroFaradAttribute : DFaradAttribute {
  mixin(AttributeThis!("MicroFaradAttribute"));

  // Initialization hook method.
  override void initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("microFarad")
      .registerPath("microFarad");
  }
}
mixin(AttributeCalls!("MicroFaradAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}