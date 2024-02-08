/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.farads.farad;

/* Unit of measure for electric capacitance in farads

Inheritance
any <- float <- double <- farad
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.capacitance
means.measurement.units.si.farad
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second
has.measurement.fundamentalComponent.ampere */

import uim.models;

@safe:
class DFaradAttribute : DDoubleAttribute {
  mixin(AttributeThis!("FaradAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("farad")
      .registerPath("farad");
  }  
}
mixin(AttributeCalls!("FaradAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}
