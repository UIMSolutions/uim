/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module  source.uim.models.classes.attributes.entities.campaign;

import uim.models;
@safe:

/* class DCampaignAttribute : DEntityAttribute {
  mixin(AttributeThis!("CampaignAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

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