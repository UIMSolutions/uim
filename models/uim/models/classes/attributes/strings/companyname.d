/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.companyname;

import uim.models;
@safe:

// means.identity.company.name
class DCompanyNameAttribute : DStringAttribute {
  mixin(AttributeThis!("CompanyNameAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    name("companyName");
    registerPath("companyName");

   return true;
  }
}
mixin(AttributeCalls!("CompanyNameAttribute"));

///
unittest {
  auto attribute = new DCompanyNameAttribute;
  assert(attribute.name == "companyName");
  assert(attribute.registerPath == "companyName");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  // IData value = attribute.createValue();
  // assert(cast(DStringData)value);
}