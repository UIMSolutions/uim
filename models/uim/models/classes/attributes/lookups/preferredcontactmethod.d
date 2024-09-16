/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.classes.attributes.lookups.preferredcontactmethod;    if (!super.initialize(initData)) {
      return false;
    }

import uim.models;

@safe:
class DPreferredContactMethodAttribute : DAttribute {
  mixin(AttributeThis!("PreferredContactMethod"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }
    // means.measurement.preferredcontactmethod

    name("preferredcontactmethod");
    dataFormats(["preferredcontactmethod"]);
    registerPath("preferredcontactmethod");

    return true;
  }

/* override Json createData() {
    return PreferredContactMethoDData(this); } */
}
mixin(AttributeCalls!("PreferredContactMethod"));

unittest {  
    // TODO tests
  }