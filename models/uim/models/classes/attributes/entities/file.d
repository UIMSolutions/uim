/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.entities.file;

import uim.models;
@safe:

/* class DFileAttribute : DEntityAttribute {
  mixin(AttributeThis!("File"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    this
      .name("file")
      .registerPath("file");
  }  
}
mixin(AttributeCalls!("File"));

version(test_uim_models) { unittest {
    testAttribute(new DFileAttribute);
    testAttribute(FileAttribute);
  }
} */