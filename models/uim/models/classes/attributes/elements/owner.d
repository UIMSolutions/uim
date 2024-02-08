/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.elements.owner;

import uim.models;

@safe:
class DOwnerElementAttribute : DAttribute {
  mixin(AttributeThis!("OwnerElementAttribute"));

  override DValue createValue() {
    return ElementValue(this)
      .value(
        Element
          .name("owner")
          .addValues([
            "id": UUIDAttribute, // Owner Id"]),
            "idType": StringAttribute, // The type of owner, either User or Team."
          ])
      );
  }
}
mixin(AttributeCalls!"OwnerElementAttribute");

version(test_uim_models) { unittest {
  testAttribute(new DOwnerElementAttribute);
  testAttribute(OwnerElementAttribute);
}}