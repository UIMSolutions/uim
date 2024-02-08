/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
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
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("companyName")
      .registerPath("companyName");
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

  DValue value = attribute.createValue();
  assert(cast(DStringValue)value);
}