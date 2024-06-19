/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.phones.fax;

/* any <- char <- string <- phoneFax
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.identity.service.phone.fax */

import uim.models;

@safe:
class DFaxAttribute : DStringAttribute {
  mixin(AttributeThis!("Fax"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    registerPath("attributes.fax");

    return true;

  }
}

mixin(AttributeCalls!("Fax"));

  unittest {
    // TODO
}
