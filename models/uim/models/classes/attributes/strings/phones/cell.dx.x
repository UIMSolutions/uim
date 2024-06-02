/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.phones.cell;

/* any <- char <- string <- phoneCell
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.identity.service.phone.cell */

import uim.models;

@safe:
class DPhoneCellAttribute : DStringAttribute {
  mixin(AttributeThis!("PhoneCell"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("phonecell");
    registerPath("phonecell");

    return true;
  }
}

mixin(AttributeCalls!("PhoneCell"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
