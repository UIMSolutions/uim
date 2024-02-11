/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.arrays.bytes.image;

/* any <- byte <- image <- image
Traits
is.dataFormat.byte
is.dataFormat.array
means.content.image.image */

import uim.models;

@safe:
class DImageAttribute : DBinaryAttribute {
  mixin(AttributeThis!("ImageAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    /* 
means.content.binary.image */
    addDataFormats(["array"]);
    name("image");
    registerPath("image");

    return true;
  }
}

mixin(AttributeCalls!("ImageAttribute"));

version (test_uim_models) {
  unittest {
    testAttribute(new DImageAttribute);
    testAttribute(ImageAttribute);
  }
}
