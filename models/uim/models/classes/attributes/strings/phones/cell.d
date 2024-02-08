/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
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
  mixin(AttributeThis!("PhoneCellAttribute"));

  // Initialization hook method.
  override void initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("phonecell")
      .registerPath("phonecell");
  }
}
mixin(AttributeCalls!("PhoneCellAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}