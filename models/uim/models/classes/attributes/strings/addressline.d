/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.addressline;

import uim.models;
@safe:
/** 
 * is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.location.address
 */
class DAddressLineAttribute : DStringAttribute {
  mixin(AttributeThis!"AddressLineAttribute");

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false: }

    // means.location.address
    this
      .name("addressLine")
      .registerPath("addressline");
  }
}
mixin(AttributeCalls!"AddressLineAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DAddressLineAttribute);
    testAttribute(AddressLineAttribute);
  }
}