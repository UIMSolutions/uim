/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.lookups.lookup;

import uim.models;

@safe:
class DLookupAttribute : DAttribute {
  mixin(AttributeThis!("LookupAttribute"));

  // Initialization hook method.
  override void initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);
    // means.measurement.lookup

    this
      .name("lookup")
      .dataFormats(["lookup"])
      .registerPath("lookup");
  }

/*   override DData createValue() {
    return LookupValue(this); } */
}
mixin(AttributeCalls!("LookupAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}