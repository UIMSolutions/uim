/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.file;

import uim.models;

@safe:
class DFileIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("FileIdAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("fileId")
      .registerPath("fileId");
  }  
}
mixin(AttributeCalls!("FileIdAttribute"));

///
unittest {
  auto attribute = new DFileIdAttribute;
  assert(attribute.name == "fileId");
  assert(attribute.registerPath == "fileId");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DData value = attribute.createValue();
  assert(cast(DUUIDData)value);
}