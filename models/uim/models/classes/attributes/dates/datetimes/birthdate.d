/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.datetimes.birthdate;

import uim.models;

@safe:
class DBirthDateAttribute : DDatetimeAttribute {
  mixin(AttributeThis!("BirthDateAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    /* is.dataFormat.date
    means.measurement.date
    is.dataFormat.time
    means.measurement.time
    means.demographic.birthDate
 */
    
      dataFormats(["time"]);
      name("birthdate");
      registerPath("birthdate");

  }
  
  /* override IData createData() {
    return DateTimeData(this); } */
}
mixin(AttributeCalls!"BirthDateAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DBirthDateAttribute);
    testAttribute(BirthDateAttribute);
  }
}