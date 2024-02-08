/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.lookups.preferredcontactmethod;

import uim.models;

@safe:
class DPreferredContactMethodAttribute : DAttribute {
  mixin(AttributeThis!("PreferredContactMethodAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false: }
    // means.measurement.preferredcontactmethod

    this
      .name("preferredcontactmethod")
      .dataFormats(["preferredcontactmethod"])
      .registerPath("preferredcontactmethod");
  }

/*   override IData createValue() {
    return PreferredContactMethoDData(this); } */
}
mixin(AttributeCalls!("PreferredContactMethodAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}