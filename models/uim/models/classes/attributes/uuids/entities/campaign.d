/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.campaign;

import uim.models;

@safe:
class DCampaignIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("CampaignId"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    registerPath("campaignId");

    return true;
  }
}

mixin(AttributeCalls!("CampaignId"));

///
unittest {
  auto attribute = new DCampaignIdAttribute;
  assert(attribute.name == "CampaignIdAttribute");
  assert(attribute.registerPath == "attributes.campaignid");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute) generalAttribute);
  assert(cast(DUUIDAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DUUIDData) value);
}
