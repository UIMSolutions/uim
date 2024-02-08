/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.languagetags.languagetag;

import uim.models;
@safe:

// means.reference.language.tag
class DLanguageTagAttribute : DStringAttribute {
  mixin(AttributeThis!("LanguageTagAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .name("languageTag")
      .registerPath("languagetag");
  }
}
mixin(AttributeCalls!("LanguageTagAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}