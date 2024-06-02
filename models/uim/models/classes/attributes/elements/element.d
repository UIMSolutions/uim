/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.elements.element;

import uim.models;

@safe:
class DElementAttribute : DAttribute {
  mixin(AttributeThis!("Element"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    return true;
  }

  /* override Json createData() {
    return ElementData(this); } */
}
mixin(AttributeCalls!"Element");

version(test_uim_models) { unittest {
  testAttribute(new Attribute);
  testAttribute(ElementAttribute);
}}