/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.campaign;

import uim.models;

@safe:
class DCampaignIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("CampaignIdAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false: }

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

  DData value = attribute.createValue();
  assert(cast(DUUIDData)value);
}