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
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("languageTag");
    registerPath("languagetag");

    return true;
  }
}

mixin(AttributeCalls!("LanguageTagAttribute"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
