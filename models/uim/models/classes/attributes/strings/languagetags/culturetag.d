/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.languagetags.culturetag;

import uim.models;

@safe:
class DCultureTagAttribute : DStringAttribute {
  mixin(AttributeThis!("CultureTag"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    /* means.reference.language.tag
    means.reference.culture.tag */
    name("languageTag");
    registerPath("languagetag");

    return true;
  }
}

mixin(AttributeCalls!("CultureTag"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
