/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.kelvin;

/* Unit of measure for thermodynamic temperature in degrees kelvin

Inheritance
any <- float <- double <- kelvin
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.temperature
means.measurement.units.si.kelvin
has.measurement.fundamentalComponent.kelvin */

import uim.models;

@safe:
class DKelvinAttribute : DDoubleAttribute {
  mixin(AttributeThis!("KelvinAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

    this
      .name("kelvin")
      .registerPath("kelvin");
  }
}
mixin(AttributeCalls!("KelvinAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}