/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module  source.uim.models.classes.attributes.entities.file;

import uim.models;
@safe:

/* class DFileAttribute : DEntityAttribute {
  mixin(AttributeThis!("FileAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false: }

    this
      .name("file")
      .registerPath("file");
  }  
}
mixin(AttributeCalls!("FileAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DFileAttribute);
    testAttribute(FileAttribute);
  }
} */