/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.meters.meter;

/* 
Unit of measure for length in meters

is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.length
means.measurement.units.si.meter
has.measurement.fundamentalComponent.meter */

import uim.models;

@safe:
class DMeterAttribute : DDoubleAttribute {
  mixin(AttributeThis!("MeterAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .name("meter")
      .registerPath("meter");
  }
}
mixin(AttributeCalls!("MeterAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}