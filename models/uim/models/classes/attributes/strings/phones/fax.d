/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
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
  mixin(AttributeThis!("FaxAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .name("fax")
      .registerPath("fax");
  }
}
mixin(AttributeCalls!("FaxAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}