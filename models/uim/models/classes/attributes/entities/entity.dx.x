/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.entities.entity;

import uim.models;
@safe:

/* class DEntityAttribute : DAttribute {
  mixin(AttributeThis!("EntityAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    this
      .dataFormats(["time"]);
    // means.measurement.date
    // means.measurement.time
  }

  override IData createData() {
    return EntityData(this); }
}
mixin(AttributeCalls!"EntityAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DEntityAttribute);
    testAttribute(EntityAttribute);
  }
} */