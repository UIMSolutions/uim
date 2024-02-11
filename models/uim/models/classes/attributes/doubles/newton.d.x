/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.newton;

/* Unit of measure for force or weight in newtons

Inheritance
any <- float <- double <- newton
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.force
means.measurement.units.si.newton
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second */

import uim.models;

@safe:
class DNewtonAttribute : DDoubleAttribute {
  mixin(AttributeThis!("NewtonAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    name("newton");
    registerPath("newton");

    return true;
  }
}

mixin(AttributeCalls!("NewtonAttribute"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
