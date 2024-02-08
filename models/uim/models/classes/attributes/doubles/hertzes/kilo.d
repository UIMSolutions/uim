/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
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
  mixin(AttributeThis!("KiloHertzAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

    this
      .name("kilohertz")
      .registerPath("kilohertz");
  }
}
mixin(AttributeCalls!("KiloHertzAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}