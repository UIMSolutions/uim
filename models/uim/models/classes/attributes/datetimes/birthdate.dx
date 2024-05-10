/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.datetimes.birthdate;

import uim.models;

@safe:
class DBirthDateAttribute : DDatetimeAttribute {
  mixin(AttributeThis!("BirthDate"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    /* is.dataFormat.date
    means.measurement.date
    is.dataFormat.time
    means.measurement.time
    means.demographic.birthDate
 */

    dataFormats(["time"]);
    name("birthdate");
    registerPath("birthdate");

    return true;
  }

  /* override Json createData() {
    return DatetimeData(this); } */
}

mixin(AttributeCalls!"BirthDate");

version (test_uim_models) {
  unittest {
    testAttribute(new DBirthDateAttribute);
    testAttribute(BirthDateAttribute);
  }
}
