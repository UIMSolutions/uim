/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.entities.entity;

import uim.models;
@safe:

/* class DEntityAttribute : DAttribute {
  mixin(AttributeThis!("Entity"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    this
      .dataFormats(["time"]);
    // means.measurement.date
    // means.measurement.time
  }

  override Json createData() {
    return EntityData(this); }
}
mixin(AttributeCalls!"Entity");

version(test_uim_models) { unittest {
    testAttribute(new DEntityAttribute);
    testAttribute(EntityAttribute);
  }
} */