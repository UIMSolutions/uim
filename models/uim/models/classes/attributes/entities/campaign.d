/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.classes.attributes.entities.campaign;    if (!super.initialize(initData)) {
      return false;
    }

import uim.models;
@safe:

/* class DCampaignAttribute : DEntityAttribute {
  mixin(AttributeThis!("Campaign"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    this
      .name("campaign")
      .registerPath("campaign");
  }  
}
mixin(AttributeCalls!("Campaign"));

version(test_uim_models) { unittest {
    testAttribute(new DCampaignAttribute);
    testAttribute(CampaignAttribute);
  }
} */