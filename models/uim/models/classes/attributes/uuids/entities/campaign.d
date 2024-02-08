/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.campaign;

import uim.models;

@safe:
class DCampaignIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("CampaignIdAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("campaignId")
      .registerPath("campaignId");
  }  
}
mixin(AttributeCalls!("CampaignIdAttribute"));

///
unittest {
  auto attribute = new DCampaignIdAttribute;
  assert(attribute.name == "campaignId");
  assert(attribute.registerPath == "campaignId");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DValue value = attribute.createValue();
  assert(cast(DUUIDValue)value);
}