/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.lookups.preferredcontactmethod;

import uim.models;

@safe:
class DPreferredContactMethodAttribute : DAttribute {
  mixin(AttributeThis!("PreferredContactMethodAttribute"));

  // Initialization hook method.
  override void initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);
    // means.measurement.preferredcontactmethod

    this
      .name("preferredcontactmethod")
      .dataFormats(["preferredcontactmethod"])
      .registerPath("preferredcontactmethod");
  }

/*   override DData createValue() {
    return PreferredContactMethoDData(this); } */
}
mixin(AttributeCalls!("PreferredContactMethodAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}