/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module models.uim.models.classes.attributes.lookups.preferredcontactmethod;

import uim.models;

@safe:
class DPreferredContactMethodAttribute : DAttribute {
  mixin(AttributeThis!("PreferredContactMethod"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }
    // means.measurement.preferredcontactmethod

    name("preferredcontactmethod");
    dataFormats(["preferredcontactmethod"]);
    registerPath("preferredcontactmethod");

    return true;
  }

/*   override Json createData() {
    return PreferredContactMethoDData(this); } */
}
mixin(AttributeCalls!("PreferredContactMethod"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}