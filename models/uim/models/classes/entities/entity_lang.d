/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.entities.entity_lang;

import uim.models;
@safe:

/* class DEntityLang : DEntity {
  this() { super(); }
  this(UUID myId) { super(myId); }
  this(string myName) { super(myName);}
  this(UUID myId, string myName) { super(myId, myName); }

  mixin(SProperty!("string", "language"));

  override Json toJson(string[] showFields = null, string[] hideFields = null) {    
    auto result = super.toJson(showFields, hideFields);
    
    result["language"] = this.language;

    return result;
  }
}
auto EntityLang() { return new DEntityLang; }

version(test_uim_models) {
  unittest {
  }
} */
