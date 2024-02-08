/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.year;

/* Unit of measure for time in 'one solar orbit' interval

Inheritance
any <- integer <- year
Traits
is.dataFormat.integer
means.measurement.dimension.time
means.measurement.duration.years
has.measurement.fundamentalComponent.second */

import uim.models;

@safe:
class DYearAttribute : DIntegerAttribute {
  mixin(AttributeThis!("YearAttribute"));

  // Initialization hook method.
  override void initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("year")
      .registerPath("year");
  }    
}
mixin(AttributeCalls!("YearAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DYearAttribute);
    testAttribute(YearAttribute);
  }
}