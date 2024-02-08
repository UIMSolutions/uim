/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.seconds.milli;

/* Unit of measure for time in 10E-3 seconds

Inheritance
any <- float <- double <- second <- milliSecond
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.time
means.measurement.units.si.second
has.measurement.fundamentalComponent.second
means.measurement.duration.seconds
means.measurement.prefix.milli */

import uim.models;

@safe:
class DMilliSecondAttribute : DSecondAttribute {
  mixin(AttributeThis!("MilliSecondAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

    this
      .name("milliSecond")
      .registerPath("milliSecond");
  }
}
mixin(AttributeCalls!("MilliSecondAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}