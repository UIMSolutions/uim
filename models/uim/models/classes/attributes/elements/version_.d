/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.elements.version_;

import uim.models;

@safe:
class DVersionElementAttribute : DAttribute {
  mixin(AttributeThis!("VersionElementAttribute"));

  override IData createValue() {
    return ElementValue(this)
      .value(
        Version        
      );
  }
}
mixin(AttributeCalls!"VersionElementAttribute");

version(test_uim_models) { unittest {
  testAttribute(new DVersionElementAttribute);
  testAttribute(VersionElementAttribute);
}}