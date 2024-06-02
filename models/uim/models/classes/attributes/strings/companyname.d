/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.companyname;

import uim.models;
@safe:

// means.identity.company.name
class DCompanyNameAttribute : DStringAttribute {
  mixin(AttributeThis!("CompanyName"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    name("companyName");
    registerPath("companyName");

   return true;
  }
}
mixin(AttributeCalls!("CompanyName"));

///
unittest {
  auto attribute = new DCompanyNameAttribute;
  assert(attribute.name == "companyName");
  assert(attribute.registerPath == "companyName");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DStringData)value);
}