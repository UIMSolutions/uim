/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module  uim.models.classes.attributes.entities.campaign;

import uim.models;
@safe:

/* class DCampaignAttribute : DEntityAttribute {
  mixin(AttributeThis!("CampaignAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .name("campaign")
      .registerPath("campaign");
  }  
}
mixin(AttributeCalls!("CampaignAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DCampaignAttribute);
    testAttribute(CampaignAttribute);
  }
} */