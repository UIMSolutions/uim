/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.elements.owner;

import uim.models;

@safe:
class DOwnerElementAttribute : DAttribute {
  mixin(AttributeThis!("OwnerElement"));

  /* override Json createData() {
    return ElementData(this)
      .value(
        Element
          .name("owner")
          .addValues([
            "id": UUIDAttribute, // Owner Id"]),
            "idType": StringAttribute, // The type of owner, either User or Team."
          ])
      );
  } */ 
}
mixin(AttributeCalls!"OwnerElement");

version(test_uim_models) { unittest {
  testAttribute(new DOwnerElementAttribute);
  testAttribute(OwnerElementAttribute);
}}