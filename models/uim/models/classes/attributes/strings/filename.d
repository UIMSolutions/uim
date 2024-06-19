/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.filename;

import uim.models;

@safe:

// A string value representing the name of a file.
class DFileNameAttribute : DStringAttribute {
  mixin(AttributeThis!("FileName"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    /* is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.fileName */
    registerPath("attributes.fileName");

    return true;
  }
}

mixin(AttributeCalls!("FileName"));

///
unittest {
  auto attribute = new DFileNameAttribute;
  assert(attribute.name == "FilenameAttribute");
  assert(attribute.registerPath == "attributes.fileName");
}
