/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.elements.element;

import uim.models;

@safe:
class DElementAttribute : DAttribute {
  mixin(AttributeThis!("ElementAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    return true;
  }

  /* override IData createValue() {
    return ElementValue(this); } */
}
mixin(AttributeCalls!"ElementAttribute");

version(test_uim_models) { unittest {
  testAttribute(new Attribute);
  testAttribute(ElementAttribute);
}}