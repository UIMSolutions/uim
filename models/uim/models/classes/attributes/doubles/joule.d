/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.joule;

/* Unit of measure for energy, work or heat in joules

Inheritance
any <- float <- double <- joule
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.energy
means.measurement.units.si.joule
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second */

import uim.models;

@safe:
class DJouleAttribute : DDoubleAttribute {
  mixin(AttributeThis!("JouleAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .name("joule")
      .registerPath("joule");
  }
}
mixin(AttributeCalls!("JouleAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}