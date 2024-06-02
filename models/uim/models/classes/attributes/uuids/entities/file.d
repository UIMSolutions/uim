/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.file;

import uim.models;

@safe:
class DFileIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("FileId"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("fileId");
    registerPath("fileId");

    return true;

  }
}

mixin(AttributeCalls!("FileId"));

///
unittest {
  auto attribute = new DFileIdAttribute;
  assert(attribute.name == "fileId");
  assert(attribute.registerPath == "fileId");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute) generalAttribute);
  assert(cast(DUUIDAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DUUIDData) value);
}
