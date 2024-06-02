/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.degree;

import uim.models;

@safe:

/* 
Unit of measure for angles in degrees, 1/360 rotation
means.measurement.dimension.angle
means.measurement.units.degree
has.measurement.fundamentalComponent */
class DDegreeAttribute : DDoubleAttribute {
  mixin(AttributeThis!("Degree"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("degree");
    registerPath("degree");

    return true;
  }
}

mixin(AttributeCalls!("Degree"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
