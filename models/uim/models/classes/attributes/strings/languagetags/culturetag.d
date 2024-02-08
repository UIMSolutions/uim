/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.languagetags.culturetag;

import uim.models;

@safe:
class DCultureTagAttribute : DStringAttribute {
  mixin(AttributeThis!("CultureTagAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    /* means.reference.language.tag
    means.reference.culture.tag */
    name("languageTag");
    registerPath("languagetag");

    return true;
  }
}

mixin(AttributeCalls!("CultureTagAttribute"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
