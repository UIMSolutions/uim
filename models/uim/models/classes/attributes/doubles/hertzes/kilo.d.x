/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.hertzes.kilo;

/* Unit of frequency equivalent to 10E3 hertz

is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.frequency
means.measurement.units.si.hertz
has.measurement.fundamentalComponent.second
means.measurement.prefix.kilo */

import uim.models;

@safe:
class DKiloHertzAttribute : DHertzAttribute {
  mixin(AttributeThis!("KiloHertz"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("kilohertz");
    registerPath("kilohertz");

    return true;
  }
}

mixin(AttributeCalls!("KiloHertz"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
