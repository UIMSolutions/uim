/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.filename;

import uim.models;
@safe:

// A string value representing the name of a file.
class DFileNameAttribute : DStringAttribute {
  mixin(AttributeThis!("FileNameAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

/* is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.fileName */
    this
      .name("filename")
      .registerPath("fileName");
  }
}
mixin(AttributeCalls!("FileNameAttribute"));

///
unittest {
  auto attribute = new DFileNameAttribute;
  assert(attribute.name == "filename");
  assert(attribute.registerPath == "fileName");
}